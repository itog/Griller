//
//  ViewController.m
//  PwmDrive
//
//  Created on 12/26/12.
//  Copyright (c) 2012 Yukai Engineering. All rights reserved.
//

#import "ViewController.h"
#import "Konashi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Konashi initialize];
    
    [Konashi addObserver:self selector:@selector(connected) name:KONASHI_EVENT_CONNECTED];
    [Konashi addObserver:self selector:@selector(ready) name:KONASHI_EVENT_READY];

    self.firePowerSlider.value = 0;
    self.rotationSpeedSlider.value = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)find:(id)sender {
    [Konashi find];
}

- (IBAction)changeLedBlightness20:(id)sender {
    [Konashi pwmLedDrive:LED2 dutyRatio:20.0];
}

- (IBAction)changeLedBlightness50:(id)sender {
    [Konashi pwmLedDrive:LED2 dutyRatio:50.0];
}

- (IBAction)changeLedBlightness80:(id)sender {
    [Konashi pwmLedDrive:LED2 dutyRatio:80.0];
}

CFAbsoluteTime previousTime = 0;
const float COMMAND_INTERVAL = 0.2;

- (IBAction)changeFirePowerBar:(id)sender {
    NSLog(@"Fire Power: %f", self.firePowerSlider.value);
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent ();
    if ((currentTime - previousTime) > COMMAND_INTERVAL) {
        NSLog(@"Rotation speed: %f", self.firePowerSlider.value);
        [Konashi pwmLedDrive:LED2 dutyRatio:self.firePowerSlider.value];
        previousTime = currentTime;
    } else {
        NSLog(@"skip");
    }
}


- (IBAction)changeRotationSpeedBar:(id)sender {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent ();
    if ((currentTime - previousTime) > COMMAND_INTERVAL) {
        NSLog(@"Rotation speed: %f", self.rotationSpeedSlider.value);
        [Konashi pwmLedDrive:LED3 dutyRatio:self.rotationSpeedSlider.value];
        previousTime = currentTime;
    } else {
        NSLog(@"skip");
    }
}

- (void) connected
{
    NSLog(@"CONNECTED");
}

- (void) ready
{
    NSLog(@"READY");
    
    
    self.statusMessage.hidden = FALSE;
    
    // Drive LED
    [Konashi pwmMode:LED2 mode:KONASHI_PWM_ENABLE_LED_MODE];
    [Konashi pwmLedDrive:LED2 dutyRatio:0.0];

    [Konashi pwmMode:LED3 mode:KONASHI_PWM_ENABLE_LED_MODE];
    [Konashi pwmLedDrive:LED3 dutyRatio:0.0];

    /*
    //Blink LED (interval: 0.5s)
    [Konashi pwmPeriod:LED2 period:1000000];   // 1.0s
    [Konashi pwmDuty:LED2 duty:500000];        // 0.5s
    [Konashi pwmMode:LED2 mode:ENABLE];
     */
}

@end

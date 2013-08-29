//
//  ShakeViewController.m
//  OrderMenu
//
//  Created by tiankong360 on 13-7-29.
//  Copyright (c) 2013年 tiankong360. All rights reserved.
//

#import "ShakeViewController.h"

@interface ShakeViewController ()

@end

#define kFilteringFactor                0.1
#define kEraseAccelerationThreshold        2.0

@implementation ShakeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canShake = YES;
    }
    return self;
}

//- (void)dealloc
//{
//    [UIAccelerometer sharedAccelerometer].delegate = nil;
//    //[super dealloc];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 1.0f/40.0f;
}


#pragma mark - UIAccelerometerDelegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue  length, x, y, z;
    
    if (!_canShake)
    {
        return;
    }
    
    //Use a basic high-pass filter to remove the influence of the gravity
    myAccelerometer[0] = acceleration.x * kFilteringFactor + myAccelerometer[0] * (1.0 - kFilteringFactor);
    myAccelerometer[1] = acceleration.y * kFilteringFactor + myAccelerometer[1] * (1.0 - kFilteringFactor);
    myAccelerometer[2] = acceleration.z * kFilteringFactor + myAccelerometer[2] * (1.0 - kFilteringFactor);
    // Compute values for the three axes of the acceleromater
    x = acceleration.x - myAccelerometer[0];
    y = acceleration.y - myAccelerometer[0];
    z = acceleration.z - myAccelerometer[0];
    
    //Compute the intensity of the current acceleration
    length = sqrt(x * x + y * y + z * z);
    // If above a given threshold, play the erase sounds and erase the drawing view
    if(length >= kEraseAccelerationThreshold)
    {
        //是否响应摇一摇的标志
        _canShake = NO;
        [self shakeEvent];
    }
}
-(void)shakeEvent
{
    NSLog(@"摇一摇");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

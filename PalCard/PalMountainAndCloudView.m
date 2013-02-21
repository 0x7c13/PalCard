//
//  PalMountainAndCloudView.m
//  MountainAndCloudView
//
//  Created by FlyinGeek on 13-2-20.
//  Copyright (c) 2013年 FY. All rights reserved.
//

#import "PalMountainAndCloudView.h"

#define MountainImg @"UIimages/main_bg.jpg"
#define CloudImg_1 @"UIimages/cloud-front.png"
#define CloudImg_2 @"UIimages/cloud-back.png"

@implementation PalMountainAndCloudView 


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) startAnimation
{
    [self startMountainAnimation];
    [self startBackCloudAnimation];
    [self startFrontCloudAnimation];
}

- (void)startMountainAnimation
{
    UIImageView *mountainView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1178, self.bounds.size.height)];
    mountainView.image = [UIImage imageNamed:MountainImg];
    
    
    CGRect frame = mountainView.frame;
    frame.origin.x = 0;
    mountainView.frame = frame;
    
    [UIView beginAnimations:@"mountainAnimation" context:NULL];
    [UIView setAnimationDuration:23.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];

    frame = mountainView.frame;
    frame.origin.x = - frame.size.width + 320;
    mountainView.frame = frame;
    
    [self addSubview:mountainView];
    [UIView commitAnimations];
}

- (void)startBackCloudAnimation
{
    
    UIImageView *backCloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1320, self.bounds.size.height)];
    backCloudView.image = [UIImage imageNamed:CloudImg_1];
    backCloudView.alpha = 0.8;
    
    CGRect frame = backCloudView.frame;
    frame.origin.x = 0;
    backCloudView.frame = frame;
    
    [UIView beginAnimations:@"backCloudAnimation" context:NULL];
    [UIView setAnimationDuration:15.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];
    
    frame = backCloudView.frame;
    frame.origin.x = -frame.size.width + 320;
    backCloudView.frame = frame;
    
    [self addSubview:backCloudView];
    [UIView commitAnimations];
}

- (void)startFrontCloudAnimation
{
    
    UIImageView *frontCloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1320, self.bounds.size.height)];
    frontCloudView.image = [UIImage imageNamed:CloudImg_2];
    //frontCloudView.alpha = 0.8;
    
    CGRect frame = frontCloudView.frame;
    frame.origin.x = 0;
    frontCloudView.frame = frame;
    
    [UIView beginAnimations:@"frontCloudAnimation" context:NULL];
    [UIView setAnimationDuration:8.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];
    
    frame = frontCloudView.frame;
    frame.origin.x = -frame.size.width + 320;
    frontCloudView.frame = frame;
    
    [self addSubview:frontCloudView];
    [UIView commitAnimations];
}

@end

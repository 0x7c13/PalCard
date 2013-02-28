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

#define MountainImgWidth 1178
#define CloudImgWidth 1320

@interface PalMountainAndCloudView () 

@property (nonatomic, strong) UIImageView *mountainView;
@property (nonatomic, strong) UIImageView *backCloudView;
@property (nonatomic, strong) UIImageView *frontCloudView;

@end


@implementation PalMountainAndCloudView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.animationStarted = NO;
    
    if (self.subviews.count == 3) {
        [self.mountainView removeFromSuperview];
        [self.backCloudView removeFromSuperview];
        [self.frontCloudView removeFromSuperview];
    }
    
    _mountainView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MountainImgWidth, self.bounds.size.height)];
    self.mountainView.image = [UIImage imageNamed:MountainImg];
        
    _backCloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CloudImgWidth, self.bounds.size.height)];
    self.backCloudView.image = [UIImage imageNamed:CloudImg_1];
    self.backCloudView.alpha = 0.8;
        
    _frontCloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CloudImgWidth, self.bounds.size.height)];
    self.frontCloudView.image = [UIImage imageNamed:CloudImg_2];
        
    [self addSubview:self.mountainView];
    [self addSubview:self.backCloudView];
    [self addSubview:self.frontCloudView];
    
}

- (void) startAnimation
{
    self.animationStarted = YES;
    
    [self startMountainAnimation];
    [self startBackCloudAnimation];
    [self startFrontCloudAnimation];
}

- (void)startMountainAnimation
{
    if(!self.animationStarted) return;
    
    self.mountainView.frame =
    CGRectMake(0, 0, MountainImgWidth, self.bounds.size.height);

    [UIView animateWithDuration: 23.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.mountainView.frame =
                         CGRectMake(- MountainImgWidth + 320, 0, MountainImgWidth, self.bounds.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         [self startMountainAnimation];
                     }];
}

- (void)startBackCloudAnimation
{
    if(!self.animationStarted) return;
    
    self.backCloudView.frame =
    CGRectMake(0, 0, CloudImgWidth, self.bounds.size.height);
    
    [UIView animateWithDuration: 15.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.backCloudView.frame =
                         CGRectMake(- CloudImgWidth + 320, 0, CloudImgWidth, self.bounds.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         [self startBackCloudAnimation];
                     }];
}

- (void)startFrontCloudAnimation
{
    if(!self.animationStarted) return;
    
    self.frontCloudView.frame =
    CGRectMake(0, 0, CloudImgWidth, self.bounds.size.height);
     
    [UIView animateWithDuration: 8.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.frontCloudView.frame =
                         CGRectMake(- CloudImgWidth + 320, 0, CloudImgWidth, self.bounds.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         [self startFrontCloudAnimation];
                     }];
}




+ (void)backgroundAnimation: (UIView *)view
{
    // black fade in/out animation
    UIImageView *blackImg = [[UIImageView alloc] initWithFrame:view.bounds];
    blackImg.backgroundColor = [UIColor blackColor];
    [view addSubview:blackImg];
    
    [UIView animateWithDuration:0.3f
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         blackImg.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [blackImg removeFromSuperview];
                     }];
    
}
@end

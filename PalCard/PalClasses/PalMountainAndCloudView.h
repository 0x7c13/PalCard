//
//  PalMountainAndCloudView.h
//  MountainAndCloudView
//
//  Created by FlyinGeek on 13-2-20.
//  Copyright (c) 2013年 FY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PalMountainAndCloudView : UIView


@property (nonatomic) bool animationStarted;

- (void)setup;
- (void)startAnimation;

// black fade in/out animation
+ (void)backgroundAnimation: (UIView *)view;

@end

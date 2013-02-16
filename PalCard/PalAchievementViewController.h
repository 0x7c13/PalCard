//
//  PalAchievementViewController.h
//  PalCard
//
//  Created by FlyinGeek on 13-2-2.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "FXImageView.h"
#import "ASMediaFocusManager.h"

@interface PalAchievementViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate, ASMediasFocusDelegate>

@property (nonatomic, retain) IBOutlet iCarousel *carousel;


@end

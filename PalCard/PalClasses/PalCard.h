//
//  PalCard.h
//  PalCard
//
//  Created by FlyinGeek on 13-2-21.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PalCard : UIView

// state of the card
@property (nonatomic) bool isVisiable;
@property (nonatomic) bool isAnimating;
@property (nonatomic) bool isBlackCard;

- (NSString *) cardName;

// set image
- (void) setImageWithPath: (NSString *)imagePath;

// do flip animation 
- (void) flipWithDuration: (NSTimeInterval) animationTime;


@end

//
//  PalCard.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-21.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalCard.h"

#define DefaultImg @"palsource/888.png"

@interface PalCard () {
    bool _initialized;
}

@property (nonatomic, copy) NSString *cardImagePath;
@property (nonatomic, strong) UIImageView *defaultView;
@property (nonatomic, strong) UIImageView *cardView;

@end

@implementation PalCard


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self cardSetup];
    }
    return self;
}

- (void) cardSetup
{
    _isVisiable = NO;
    _isAnimating = NO;
    _isBlackCard = NO;
    
    if(!_initialized) {
        _defaultView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.defaultView.image = [UIImage imageNamed:DefaultImg];
        [self addShadow:self.defaultView];
    
        _cardView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addShadow:self.cardView];
        self.cardView.alpha = 0.0f;
    
        [self addSubview:self.cardView];
        [self addSubview:self.defaultView];
        _cardImagePath = nil;
    }
    
    _initialized = YES;
}

- (void)addShadow: (UIImageView *)view
{
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowOffset:CGSizeMake(8.0f, 8.0f)];
    [view.layer setShadowOpacity:0.4f];
    [view.layer setShadowRadius:6.0f];
    
    // improve performance
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
}


- (void) setImageWithPath:(NSString *)imagePath
{
    [self cardSetup];
    
    self.cardImagePath = imagePath;
    self.cardView.image = [UIImage imageNamed:self.cardImagePath];
}

- (NSString *) cardName
{
    return self.cardImagePath;
}

- (void) flipWithDuration: (NSTimeInterval) animationTime
{
    if (!self.isVisiable) {
        
        self.isVisiable = YES;
        self.isAnimating = YES;
        
        self.cardView.alpha = 1.0f;
        [UIView transitionFromView:self.defaultView toView:self.cardView duration:animationTime options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished){
                self.isAnimating = NO;
        }];
        [UIView commitAnimations];

    }
    else {
        
        self.isVisiable = NO;
        self.isAnimating = YES;
        
        [UIView transitionFromView:self.cardView toView:self.defaultView duration:animationTime options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished){
                self.isAnimating = NO;
        }];
        [UIView commitAnimations];
        self.cardView.alpha = 0.0f;
    }

}

@end

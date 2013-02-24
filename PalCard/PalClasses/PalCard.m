//
//  PalCard.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-21.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalCard.h"

#define DefaultImg @"palsource/888.png"

@interface PalCard ()

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
    _isDisappear = NO;
    
    if (self.subviews.count == 0) {
        
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
        [UIView transitionFromView:self.defaultView
                            toView:self.cardView
                          duration:animationTime
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                                self.isAnimating = NO;
        }];
        [UIView commitAnimations];

    }
    else if(self.isVisiable) {
        
        self.isVisiable = NO;
        self.isAnimating = YES;
        
        [UIView transitionFromView:self.cardView
                            toView:self.defaultView
                          duration:animationTime
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        completion:^(BOOL finished){
                                self.isAnimating = NO;
        }];
        [UIView commitAnimations];
        self.cardView.alpha = 0.0f;
    }

}

- (void) disappearWithDuration:(NSTimeInterval)animationTime
{
    if(!self.isDisappear) {
        
         self.isAnimating = YES;
         self.isDisappear = YES;
        
        [self.defaultView removeFromSuperview];
        
        [UIView animateWithDuration:animationTime
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.cardView.alpha = 0.0;
                             self.cardView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
                         }
                         completion:^(BOOL finished){
                             [self.cardView removeFromSuperview];
                             self.isAnimating = NO;
                         }];
    }
}

- (void) shakeWithDuration:(NSTimeInterval)animationTime
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t,-t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity,-t, t);
    
    self.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];    // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    self.transform = rightQuake;    // end here & auto-reverse
    
    [UIView commitAnimations];
}


- (void) moveTo:(CGRect)position withDuration:(NSTimeInterval)animationTime
{

    self.isAnimating = YES;
        
    [UIView animateWithDuration:animationTime
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                            self.frame = position;
                    }
                    completion:^(BOOL finished){
                        self.isAnimating = NO;
    }];

}


@end

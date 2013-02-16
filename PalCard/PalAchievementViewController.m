//
//  PalAchievementViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-2.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAchievementViewController.h"
#import "MCSoundBoard.h"

#define ITEM_SPACING 200

#define _BGPIC @"UIimages/main_bg.jpg"
#define _BGPIC2 @"UIimages/cloud-front.png"
#define _BGPIC3 @"UIimages/cloud-back.png"
#define _LOGOPIC @"UIimages/main_logo.png"

#define _DefaultCardImg @"palsource/888.png"

#define _ReturnButtonImg @"UIimages/back.png"
#define _ReturnButtonPressedImg @"UIimages/back_push.png"
#define _InfoBG @"UIimages/info_bg.png"
#define _NameTagImg @"UIimages/NameTag2.png"

#define _ButtonPressedSound @"button_pressed.wav"
#define _MenuSelectedSound @"selected.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)



@interface PalAchievementViewController (){
    bool _soundOff;
    int _amountOfUnlockedCards;
}

@property (strong, nonatomic) IBOutlet UIImageView *bgPic;
@property (strong, nonatomic) IBOutlet UIImageView *bgPic2;
@property (strong, nonatomic) IBOutlet UIImageView *blackBG;
@property (strong, nonatomic) IBOutlet UILabel *descriptionDisplay;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UILabel *cardNameDisplay;
@property (strong, nonatomic) IBOutlet UILabel *achDisplay;
@property (strong, nonatomic) IBOutlet UIImageView *achLabel;
@property (strong, nonatomic) IBOutlet UIImageView *nameTag;

@property (strong) NSMutableArray *cardsInformation;
@property (strong) NSMutableArray *CardIsUnlocked;


@end

@implementation PalAchievementViewController

@synthesize carousel;



- (void)backgroundAnimation
{
    
    // Background  animation
    
    self.blackBG.alpha = 1.0;
    
    self.bgPic.image  = [UIImage imageNamed:_BGPIC];
    self.bgPic2.image = [UIImage imageNamed:_BGPIC2];
    
    self.bgPic2.alpha = 0.7;
    
    
    // mountain
    
    CGRect frame = self.bgPic.frame;
    frame.origin.x = 0;
    self.bgPic.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:20.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];
    
    frame = self.bgPic.frame;
    frame.origin.x = -frame.size.width + 320;
    self.bgPic.frame = frame;
    
    [UIView commitAnimations];
    
    // cloud
    
    CGRect frame2 = self.bgPic2.frame;
    frame2.origin.x = 0;
    self.bgPic2.frame = frame2;
    
    [UIView beginAnimations:@"testAnimation2" context:NULL];
    [UIView setAnimationDuration:8.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];
    
    frame2 = self.bgPic2.frame;
    frame2.origin.x = -frame2.size.width + 285;
    self.bgPic2.frame = frame2;
    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    self.blackBG.alpha = 0.0f;
    [UIView commitAnimations];
    
    
}

- (void) restartAnimation{
    
    [self backgroundAnimation];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.cardNameDisplay setFrame:CGRectMake(35, 10, 250, 38)];
        
        [self.nameTag setFrame:CGRectMake(35, 15, 250, 38)];
        
        [self.returnButton setFrame:CGRectMake(250, 435, 50, 35)];
        
        [self.descriptionDisplay setFrame:CGRectMake(44, 315, 232, 120)];
        
        [self.achLabel setFrame:CGRectMake(19, 320, 283, 115)];
        
        [self.carousel setFrame:CGRectMake(0, 25, 320, 320)];
        
        [self.achDisplay setFrame:CGRectMake(44, 430, 180, 40)];
    }
    
    
    // carousel view initialization
    
    _amountOfUnlockedCards = 0;
    
    self.CardIsUnlocked = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"CardIsUnlocked"]];
    
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeCoverFlow;
    
    for (int i = 0; i < 64; i++) {
        if([[self.CardIsUnlocked objectAtIndex:i] isEqualToString:@"YES"]) {
            _amountOfUnlockedCards ++;
        }
    }
    
    self.achDisplay.text = [NSString stringWithFormat: @"卡牌解锁进度:%.1f%%",(float)_amountOfUnlockedCards * 100.0 / 64.0];
    
    
    // read cards information from CardsInformation.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CardsInformation" ofType:@"plist"];
    
    _cardsInformation = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    
    // default settings for labels
    [self.descriptionDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:25]];
    
    self.descriptionDisplay.numberOfLines = 5;
    
    self.descriptionDisplay.text = self.cardsInformation[1][1];
    
    [self.cardNameDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:30]];
    
    self.cardNameDisplay.text = self.cardsInformation[1][0];
    
    
    // check whether user has turned off sound
    NSString *turnOffSound = [[NSUserDefaults standardUserDefaults] valueForKey:@"turnOffSound"];
    
    if (turnOffSound) {
        
        if ([turnOffSound isEqualToString:@"YES"]) {
            _soundOff = YES;
        }
        else if ([turnOffSound isEqualToString:@"NO"]) {
            _soundOff = NO;
            
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_ButtonPressedSound ofType:nil] forKey:@"button"];
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_MenuSelectedSound ofType:nil] forKey:@"selected"];
        }
    }
    
    
    // set default images for return button
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonImg] forState:UIControlStateNormal];
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonPressedImg] forState:UIControlStateHighlighted];
    
    self.nameTag.image = [UIImage imageNamed:_NameTagImg];
    
    
    // start back ground animation
    [self backgroundAnimation];
}


- (void)viewDidUnload
{
    [self setNameTag:nil];
    [super viewDidUnload];
    
    self.carousel = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
    
    // register for later use:
    // restart animation when game enter to foreground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void) viewDidDisappear:(BOOL)animated{
    
    // unregister when view disappear
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (IBAction)returnBottonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - protocol

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    for (UIView *view in self.carousel.visibleItemViews)
    {
        view.alpha = 1.0;
    }
    
    [UIView beginAnimations:nil context:nil];
    carousel.type = buttonIndex;
    [UIView commitAnimations];
    
}

// iCarousel Class protocol


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"selected"];
    }

}

- (void)carouselCurrentItemIndexDidChange:(NSInteger)index
{
    
    self.cardNameDisplay.text = self.cardsInformation[index + 1][0];
    self.descriptionDisplay.text = self.cardsInformation[index + 1][1];

}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 64;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    index ++; // default start from 0
    
    if ([[self.CardIsUnlocked objectAtIndex:index] isEqualToString:@"NO"]) {
        view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_DefaultCardImg]];
        
        return view;
    }
    
    
    if (index < 10) {
        view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"palsource/30%d.png",index]]];
    }
    else {
        view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"palsource/3%d.png",index]]];
    }
    
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{

    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

/*
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;
{
    return iCarouselOptionWrap;
}
*/


@end

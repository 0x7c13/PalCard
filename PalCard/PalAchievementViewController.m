//
//  PalAchievementViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-2.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAchievementViewController.h"
#import "PalDataViewController.h"
#import "PalMountainAndCloudView.h"
#import "MCSoundBoard.h"

#define ITEM_SPACING 200

#define _LOGOPIC @"UIimages/main_logo.png"

#define _DefaultCardImg @"palsource/888.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"
#define _InfoBG @"UIimages/info_bg.png"
#define _NameTagImg @"UIimages/NameTag2.png"
#define _AchLabelImg @"UIimages/ach_progress_bar.png"

#define _ButtonPressedSound @"button_pressed.wav"
#define _MenuSelectedSound @"selected.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)



@interface PalAchievementViewController (){
    bool _dataButtonPressed;
    bool _soundOff;
    int _amountOfUnlockedCards;
}

@property (weak, nonatomic) IBOutlet PalMountainAndCloudView *bgAnimationView;
@property (strong, nonatomic) IBOutlet UIImageView *blackBG;
@property (strong, nonatomic) IBOutlet UILabel *descriptionDisplay;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UILabel *cardNameDisplay;
@property (strong, nonatomic) IBOutlet UILabel *achDisplay;
@property (strong, nonatomic) IBOutlet UIImageView *achLabel;
@property (strong, nonatomic) IBOutlet UIImageView *nameTag;
@property (strong, nonatomic) IBOutlet UIImageView *achLabelBG;
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;


@property (strong) NSMutableArray *cardsInformation;
@property (strong) NSMutableArray *CardIsUnlocked;

@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;
@property (strong, nonatomic) NSMutableArray *cardViews;

@property (strong, nonatomic) IBOutlet UIButton *dataButton;

@end

@implementation PalAchievementViewController

@synthesize carousel;



- (void)backgroundAnimation
{
    
    // Background  animation
    
    self.blackBG.alpha = 1.0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.3];
    self.blackBG.alpha = 0.0f;
    [UIView commitAnimations];
    
}

- (void) restartAnimation{
    
    [self.bgAnimationView setup];
    [self.bgAnimationView startAnimation];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.cardNameDisplay setFrame:CGRectMake(35, 10, 250, 38)];
        
        [self.nameTag setFrame:CGRectMake(35, 15, 250, 38)];
        
        [self.returnButton setFrame:CGRectMake(250, 435, 50, 45)];
        
        [self.descriptionDisplay setFrame:CGRectMake(44, 315, 232, 120)];
        
        [self.achLabel setFrame:CGRectMake(19, 320, 283, 115)];
        
        [self.carousel setFrame:CGRectMake(0, 23, 320, 320)];
        
        [self.achDisplay setFrame:CGRectMake(65, 430, 180, 40)];
        
        [self.achLabelBG setFrame:CGRectMake(25, 440, 225, 23)];
        
        [self.indexLabel setFrame:CGRectMake(225, 400, 60, 20)];
        
        [self.dataButton setFrame:CGRectMake(270, 23, 18, 19)];
        
        [self.bgAnimationView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    
    // cards init
    _amountOfUnlockedCards = 0;
    self.CardIsUnlocked = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"CardIsUnlocked"]];
    [self prepareForCardsViews];
    
    
    // ASMediaFocus init
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    [self.mediaFocusManager installOnViews:self.cardViews];
    
    
    // carousel view init
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeCoverFlow;
    
    for (int i = 1; i <= 64; i++) {
        if([[self.CardIsUnlocked objectAtIndex:i] isEqualToString:@"YES"]) {
            _amountOfUnlockedCards ++;
        }
    }
    
    self.achDisplay.text = [NSString stringWithFormat: @"卡牌解锁进度: %.1f%%",(float)_amountOfUnlockedCards * 100.0 / 64.0];
    self.indexLabel.text = [NSString stringWithFormat:@"1/64"];
    
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
    
    self.achLabelBG.image = [UIImage imageNamed:_AchLabelImg];
    
    [self.achDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:17]];
    
    [self.bgAnimationView setup];
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
    
    [self.bgAnimationView setup];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}


-(void) viewDidDisappear:(BOOL)animated{
    
    // unregister when view disappear
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) viewDidAppear:(BOOL)animated
{
    if (_dataButtonPressed) {
        [self.bgAnimationView startAnimation];
        _dataButtonPressed = NO;
    }
    else {
        [self backgroundAnimation];
        [self.bgAnimationView startAnimation];
    }
}



- (IBAction)dataButtonPressed:(UIButton *)sender {
    
    _dataButtonPressed = YES;
    PalDataViewController *dataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dataSegue"];
    
    dataVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:dataVC animated:YES completion:nil];
}


- (IBAction)returnBottonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma prepare for Image Views

- (void) prepareForCardsViews
{
    _cardViews = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 64; i++)
    {
        UIView *view;
        NSString *viewPath;
    
        if ([[self.CardIsUnlocked objectAtIndex:i] isEqualToString:@"NO"]) {
            viewPath = _DefaultCardImg;
            
        }
        else if (i < 10) {
            viewPath = [NSString stringWithFormat:@"palsource/30%d.png", i];
        }
        else {
            viewPath = [NSString stringWithFormat:@"palsource/3%d.png", i];
        }
   
        FXImageView *imageView = [[FXImageView alloc] initWithFrame:CGRectMake(70, 80, 180, 260)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        //imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        //imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 0.0f;
        
        [self addShadow:imageView];
        view = imageView;
 
        //load image
        [(FXImageView *)view setImage:[UIImage imageNamed:viewPath]];
        
        [self.cardViews addObject:view];
    }


}

- (void)addShadow: (UIImageView *)view
{
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowOffset:CGSizeMake(10.0f, 10.0f)];
    [view.layer setShadowOpacity:0.4];
    [view.layer setShadowRadius:6.0];
    
    // improve performance
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
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

#pragma mark - iCarousel protocol


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
    self.indexLabel.text = [NSString stringWithFormat:@"%d/64", index + 1];

}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 64;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{    
    return self.cardViews[index];
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


#pragma mark - ASMediaFocusDelegate

- (UIImage *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager imageForView:(UIView *)view
{
    return ((UIImageView *)view).image;
}

// Returns the final focused frame for this media view. This frame is usually a full screen frame.
- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameforView:(UIView *)view
{
    return self.parentViewController.view.bounds;
}

// Returns the view controller in which the focus controller is going to be added.
// This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self.parentViewController;
}


// Returns a local media path, it must be an image path. This path is used to create an image at full screen.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaPathForView:(UIView *)view
{
    NSString *path;
    NSString *name;
    
    int i = [self.cardViews indexOfObject:view] + 1;
    
    if ([[self.CardIsUnlocked objectAtIndex:i] isEqualToString:@"NO"]) {
        name = _DefaultCardImg;
    }
    else if (i < 10) {
        name = [NSString stringWithFormat:@"palsource/30%d.png", i];
    }
    else {
        name = [NSString stringWithFormat:@"palsource/3%d.png", i];
    }
    
    path = [[NSBundle mainBundle] pathForResource:name ofType:nil];

    
    return path;
}



- (void)viewDidUnload
{
    [self setNameTag:nil];
    [self setAchDisplay:nil];
    [self setAchLabel:nil];
    [self setBlackBG:nil];
    [self setCardIsUnlocked:nil];
    [self setCardNameDisplay:nil];
    [self setCardsInformation:nil];
    [self setCardViews:nil];
    [self setCarousel:nil];
    [self setAchLabelBG:nil];
    [self setIndexLabel:nil];
    [self setDataButton:nil];
    [self setBgAnimationView:nil];
    [super viewDidUnload];
    
}


@end

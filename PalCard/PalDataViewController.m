//
//  PalDataViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-16.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalDataViewController.h"

#define _BGPIC @"UIimages/main_bg.jpg"
#define _BGPIC2 @"UIimages/cloud-front.png"
#define _BGIMG @"palsource/shushan_gaosi.png"
#define _InfoBG @"UIimages/info_bg.png"

#define _EasyImg @"UIimages/easy.png"
#define _NormalImg @"UIimages/normal.png"
#define _HardImg @"UIimages/hard.png"
#define _FreeImg @"UIimages/free_ins.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


@interface PalDataViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *easyImg;
@property (strong, nonatomic) IBOutlet UIImageView *normalImg;
@property (strong, nonatomic) IBOutlet UIImageView *hardImg;
@property (strong, nonatomic) IBOutlet UIImageView *freeImg;
@property (strong, nonatomic) IBOutlet UITextView *text1;
@property (strong, nonatomic) IBOutlet UITextView *text2;
@property (strong, nonatomic) IBOutlet UITextView *text3;
@property (strong, nonatomic) IBOutlet UITextView *text4;

@property (strong, nonatomic) IBOutlet UIImageView *infoBG;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;

@property (strong, nonatomic) IBOutlet UIImageView *bgPic;
@property (strong, nonatomic) IBOutlet UIImageView *bgPic2;
@property (strong, nonatomic) IBOutlet UIImageView *blackBG;

@end

@implementation PalDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



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


- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
    
    
    // register for later use:
    // restart animation when game enter to foreground
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    // unregister when view disappear
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) restartAnimation{
    
    [self backgroundAnimation];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!DEVICE_IS_IPHONE5) {
        
        [self.easyImg setFrame:CGRectMake(25, 15, 90, 54)];
        [self.normalImg setFrame:CGRectMake(25, 118, 90, 54)];
        [self.hardImg setFrame:CGRectMake(25, 220, 90, 54)];
        [self.freeImg setFrame:CGRectMake(25, 318, 90, 54)];
        
        [self.text1 setFrame:CGRectMake(35, 50, 168, 98)];
        [self.text2 setFrame:CGRectMake(35, 150, 168, 98)];
        [self.text3 setFrame:CGRectMake(35, 252, 168, 98)];
        [self.text4 setFrame:CGRectMake(35, 350, 168, 80)];
        
        [self.infoBG setFrame:CGRectMake(-10, 5, 340, 455)];
        
        [self.returnButton setFrame:CGRectMake(250, 435, 50, 45)];
        
    }
    
    self.easyImg.image = [UIImage imageNamed:_EasyImg];
    self.normalImg.image = [UIImage imageNamed:_NormalImg];
    self.hardImg.image = [UIImage imageNamed:_HardImg];
    self.freeImg.image = [UIImage imageNamed:_FreeImg];
    self.infoBG.image = [UIImage imageNamed:_InfoBG];
    self.infoBG.alpha = 0.6;
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonImg] forState:UIControlStateNormal];
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonPressedImg] forState:UIControlStateHighlighted];
    
 
    [self.text1 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:16]];

    [self.text2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:16]];

    [self.text3 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:16]];

    [self.text4 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:16]];

    
	// Do any additional setup after loading the view.
    
    [self showData];
    
    //self.viewDeckController.closeSlideAnimationDuration = 0.5f;
    
    // start background animation
    [self backgroundAnimation];
}


- (void) showData
{
    NSNumber *totalEasyWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalEasyWins"];
    NSNumber *totalNormalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalNormalWins"];
    NSNumber *totalHardWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalHardWins"];
    NSNumber *totalFreeWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalFreeWins"];
    
    NSNumber *totalEasyLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalEasyLosses"];
    NSNumber *totalNormalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalNormalLosses"];
    NSNumber *totalHardLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalHardLosses"];
    NSNumber *totalFreeLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalFreeLosses"];
    
    NSNumber *easyWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"easyWins"];
    NSNumber *normalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"normalWins"];
    NSNumber *hardWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"hardWins"];
    NSNumber *freeWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"freeWins"];
    
    NSNumber *easyLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"easyLosses"];
    NSNumber *normalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"normalLosses"];
    NSNumber *hardLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"hardLosses"];
    NSNumber *freeLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"freeLosses"];
    

    self.text1.text = [NSString stringWithFormat:@"总计获胜次数: %@\n总计失败次数: %@\n连续获胜次数: %@\n连续失败次数: %@", totalEasyWins, totalEasyLosses, easyWins, easyLosses ];

    self.text2.text = [NSString stringWithFormat:@"总计获胜次数: %@\n总计失败次数: %@\n连续获胜次数: %@\n连续失败次数: %@", totalNormalWins, totalNormalLosses, normalWins, normalLosses];
    
    self.text3.text = [NSString stringWithFormat:@"总计获胜次数: %@\n总计失败次数: %@\n连续获胜次数: %@\n连续失败次数: %@", totalHardWins, totalHardLosses, hardWins, hardLosses];

    self.text4.text = [NSString stringWithFormat:@"总计获胜次数: %@\n总计失败次数: %@\n连续获胜次数: %@\n连续失败次数: %@", totalFreeWins, totalFreeLosses, freeWins, freeLosses];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setEasyImg:nil];
    [self setNormalImg:nil];
    [self setHardImg:nil];
    [self setFreeImg:nil];
    [self setText1:nil];
    [self setText2:nil];
    [self setText3:nil];
    [self setText4:nil];
    [self setInfoBG:nil];
    [self setReturnButton:nil];
    [self setBgPic:nil];
    [self setBgPic2:nil];
    [self setBlackBG:nil];
    [super viewDidUnload];
}


- (IBAction)returnButtonPressed:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];

}
@end

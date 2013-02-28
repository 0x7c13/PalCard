//
//  PalDataViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-16.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalDataViewController.h"
#import "PalMountainAndCloudView.h"
#import "MCSoundBoard.h"

#define _BGIMG @"palsource/shushan_gaosi.png"
#define _InfoBG @"UIimages/info_bg.png"

#define _EasyImg @"UIimages/easy.png"
#define _NormalImg @"UIimages/normal.png"
#define _HardImg @"UIimages/hard.png"
#define _FreeImg @"UIimages/free_ins.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"
#define _ButtonPressedSound @"button_pressed.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


@interface PalDataViewController (){
    bool _soundOff;
}

@property (strong, nonatomic) IBOutlet UIImageView *easyImg;
@property (strong, nonatomic) IBOutlet UIImageView *normalImg;
@property (strong, nonatomic) IBOutlet UIImageView *hardImg;
@property (strong, nonatomic) IBOutlet UIImageView *freeImg;
@property (strong, nonatomic) IBOutlet UITextView *text1;
@property (strong, nonatomic) IBOutlet UITextView *text2;
@property (strong, nonatomic) IBOutlet UITextView *text3;
@property (strong, nonatomic) IBOutlet UITextView *text4;
@property (strong, nonatomic) IBOutlet UITextView *text1_2;
@property (strong, nonatomic) IBOutlet UITextView *text2_2;
@property (strong, nonatomic) IBOutlet UITextView *text3_2;
@property (strong, nonatomic) IBOutlet UITextView *text4_2;

@property (strong, nonatomic) IBOutlet UIImageView *infoBG;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;

@property (weak, nonatomic) IBOutlet PalMountainAndCloudView *bgAnimationView;

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


- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)stopAnimation
{
    self.bgAnimationView.animationStarted = NO;
}

- (void)restartAnimation
{
    if(!_bgAnimationView.animationStarted){
        
        [self.bgAnimationView setup];
        [self.bgAnimationView startAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.bgAnimationView.animationStarted = NO;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    if(!self.bgAnimationView.animationStarted) {
        [self.bgAnimationView startAnimation];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!DEVICE_IS_IPHONE5) {
        
        [self.easyImg setFrame:CGRectMake(25, 25, 100, 60)];
        [self.normalImg setFrame:CGRectMake(25, 115,100, 60)];
        [self.hardImg setFrame:CGRectMake(25, 210, 100, 60)];
        [self.freeImg setFrame:CGRectMake(25, 305, 100, 60)];
        
        [self.text1 setFrame:CGRectMake(25, 65, 170, 80)];
        [self.text2 setFrame:CGRectMake(25, 160, 170, 80)];
        [self.text3 setFrame:CGRectMake(25, 255, 170, 80)];
        [self.text4 setFrame:CGRectMake(25, 345, 170, 80)];
        [self.text1_2 setFrame:CGRectMake(140, 65, 170, 80)];
        [self.text2_2 setFrame:CGRectMake(140, 160, 170, 80)];
        [self.text3_2 setFrame:CGRectMake(140, 255, 170, 80)];
        [self.text4_2 setFrame:CGRectMake(140, 345, 170, 80)];
        
        [self.infoBG setFrame:CGRectMake(-10, 5, 340, 455)];
        
        [self.returnButton setFrame:CGRectMake(250, 435, 50, 45)];
        
        [self.bgAnimationView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    // check whether user has turned off sound
    NSString *turnOffSound = [[NSUserDefaults standardUserDefaults] valueForKey:@"turnOffSound"];
    
    if (turnOffSound) {
        
        if ([turnOffSound isEqualToString:@"YES"]) {
            _soundOff = YES;
        }
        else if ([turnOffSound isEqualToString:@"NO"]) {
            _soundOff = NO;
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_ButtonPressedSound ofType:nil] forKey:@"button"];
        }
    }
    
    self.easyImg.image = [UIImage imageNamed:_EasyImg];
    self.normalImg.image = [UIImage imageNamed:_NormalImg];
    self.hardImg.image = [UIImage imageNamed:_HardImg];
    self.freeImg.image = [UIImage imageNamed:_FreeImg];
    self.infoBG.image = [UIImage imageNamed:_InfoBG];
    self.infoBG.alpha = 0.7;
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonImg] forState:UIControlStateNormal];
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonPressedImg] forState:UIControlStateHighlighted];
    
 
    [self.text1 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    [self.text1_2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];

    [self.text2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    [self.text2_2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];

    [self.text3 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    [self.text3_2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    
    [self.text4 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    [self.text4_2 setFont:[UIFont fontWithName:@"DuanNing-XIng" size:18]];
    
	// Do any additional setup after loading the view.
    
    [self showData];
    [self.bgAnimationView setup];

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
    

    self.text1.text = [NSString stringWithFormat:@"获胜次数: %@\n失败次数: %@", totalEasyWins, totalEasyLosses];
    self.text1_2.text = [NSString stringWithFormat:@"连续获胜次数: %@\n连续失败次数: %@", easyWins, easyLosses ];

    self.text2.text = [NSString stringWithFormat:@"获胜次数: %@\n失败次数: %@", totalNormalWins, totalNormalLosses];
    self.text2_2.text = [NSString stringWithFormat:@"连续获胜次数: %@\n连续失败次数: %@", normalWins, normalLosses];

    self.text3.text = [NSString stringWithFormat:@"获胜次数: %@\n失败次数: %@", totalHardWins, totalHardLosses];
    self.text3_2.text = [NSString stringWithFormat:@"连续获胜次数: %@\n连续失败次数: %@", hardWins, hardLosses];

    self.text4.text = [NSString stringWithFormat:@"获胜次数: %@\n失败次数: %@", totalFreeWins, totalFreeLosses];
    self.text4_2.text = [NSString stringWithFormat:@"连续获胜次数: %@\n连续失败次数: %@", freeWins, freeLosses];

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
    [self setText1_2:nil];
    [self setText2_2:nil];
    [self setText3_2:nil];
    [self setText4_2:nil];
    [self setBgAnimationView:nil];
    [super viewDidUnload];
}


- (IBAction)returnButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

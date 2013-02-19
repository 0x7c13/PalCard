//
//  PalInstructionViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-5.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//


#import "PalInstructionViewController.h"
#import "MCSoundBoard.h"

#define _BGPIC @"UIimages/main_bg.jpg"
#define _BGPIC2 @"UIimages/cloud-front.png"
#define _BGPIC3 @"UIimages/cloud-back.png"
#define _LOGOPIC @"UIimages/main_logo.png"
#define _EasyImg @"UIimages/easy.png"
#define _NormalImg @"UIimages/normal.png"
#define _HardImg @"UIimages/hard.png"
#define _FreeImg @"UIimages/free_ins.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"
#define _InfoBG @"UIimages/info_bg.png"

#define _ButtonPressedSound @"button_pressed.wav"


#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)




@interface PalInstructionViewController (){
    bool _soundOff;
}

@property (strong, nonatomic) IBOutlet UIImageView *bgPic;
@property (strong, nonatomic) IBOutlet UIImageView *bgPic2;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIImageView *blackBG;
@property (strong, nonatomic) IBOutlet UIImageView *infoBG;
@property (strong, nonatomic) IBOutlet UIImageView *easyView;
@property (strong, nonatomic) IBOutlet UIImageView *normalView;
@property (strong, nonatomic) IBOutlet UIImageView *hardView;
@property (strong, nonatomic) IBOutlet UIImageView *freeView;
@property (strong, nonatomic) IBOutlet UITextView *text1;
@property (strong, nonatomic) IBOutlet UITextView *text2;
@property (strong, nonatomic) IBOutlet UITextView *text3;
@property (strong, nonatomic) IBOutlet UITextView *text4;

@end

@implementation PalInstructionViewController



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
    [UIView setAnimationDuration:0.3];
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S 
    if (!DEVICE_IS_IPHONE5) {
        
        [self.easyView setFrame:CGRectMake(30, 15, 110, 66)];
        [self.normalView setFrame:CGRectMake(160, 95, 110, 66)];
        [self.hardView setFrame:CGRectMake(30, 220, 110, 66)];
        [self.freeView setFrame:CGRectMake(160, 325, 110, 66)];
        
        [self.text1 setFrame:CGRectMake(40, 60, 240, 95)];
        [self.text2 setFrame:CGRectMake(40, 140, 240, 95)];
        [self.text3 setFrame:CGRectMake(40, 270, 240, 95)];
        [self.text4 setFrame:CGRectMake(40, 370, 240, 95)];
        
        [self.infoBG setFrame:CGRectMake(-10, 5, 340, 450)];
        
        [self.returnButton setFrame:CGRectMake(250, 435, 50, 45)];
    }
    
    // set default images
    self.easyView.image = [UIImage imageNamed:_EasyImg];
    self.normalView.image = [UIImage imageNamed:_NormalImg];
    self.hardView.image = [UIImage imageNamed:_HardImg];
    self.freeView.image = [UIImage imageNamed:_FreeImg];
    self.infoBG.image = [UIImage imageNamed:_InfoBG];
    
    // set images for return button
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonImg] forState:UIControlStateNormal];
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonPressedImg] forState:UIControlStateHighlighted];
    
    
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
    

    // start background animation
    [self backgroundAnimation];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setBgPic:nil];
    [self setBgPic2:nil];
    [self setReturnButton:nil];
    [self setBlackBG:nil];
    [self setInfoBG:nil];
    [self setEasyView:nil];
    [self setNormalView:nil];
    [self setHardView:nil];
    [self setText1:nil];
    [self setText2:nil];
    [self setText3:nil];
    [self setFreeView:nil];
    [self setText4:nil];
    [super viewDidUnload];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}


@end

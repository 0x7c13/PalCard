//
//  PalInformationViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-5.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalInformationViewController.h"
#import "PalMountainAndCloudView.h"
#import "MCSoundBoard.h"

#define _LOGOPIC @"UIimages/main_logo.png"

#define _DefaultCardImg @"palsource/888.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"
#define _InfoBG @"UIimages/info_bg.png"
#define _NameTagImg @"UIimages/NameTag2.png"

#define _ButtonPressedSound @"button_pressed.wav"
#define _MenuSelectedSound @"selected.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)




@interface PalInformationViewController () {
    bool _soundOff;
}


@property (strong, nonatomic) IBOutlet PalMountainAndCloudView *bgAnimationView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIImageView *blackBG;
@property (strong, nonatomic) IBOutlet UIImageView *infoBG;
@property (strong, nonatomic) IBOutlet UITextView *textInfo;

@end

@implementation PalInformationViewController



- (void)backgroundAnimation
{
    
    self.blackBG.alpha = 1.0;    
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
    
    [self backgroundAnimation];
    [self.bgAnimationView startAnimation];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    // unregister when view disappear
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) restartAnimation{
    [self.bgAnimationView setup];
    [self.bgAnimationView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
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

    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.infoBG setFrame:CGRectMake(-10, 5, 340, 445)];
        
        [self.textInfo setFrame:CGRectMake(27, 35, 266, 373)];
        
        [self.returnButton setFrame:CGRectMake(250, 430, 50, 45)];
        
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
    
    
    // set default images for return button
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonImg] forState:UIControlStateNormal];
    
    [self.returnButton setBackgroundImage:[UIImage imageNamed:_ReturnButtonPressedImg] forState:UIControlStateHighlighted];
    
    self.infoBG.image = [UIImage imageNamed:_InfoBG];
    
    [self.bgAnimationView setup];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setReturnButton:nil];
    [self setBlackBG:nil];
    [self setInfoBG:nil];
    [self setTextInfo:nil];
    [self setBgAnimationView:nil];
    [super viewDidUnload];
}



- (IBAction)returnBottonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end

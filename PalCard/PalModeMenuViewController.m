//
//  PalModeMenuViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-1.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalModeMenuViewController.h"
#import "PalViewController.h"
#import "PalMountainAndCloudView.h"
#import "MCSoundBoard.h"

#define _ModeChoiceLabelImg @"UIimages/difficulty_choice.png"

#define _EasyModeButtonImg @"UIimages/easy2.png"
#define _EasyModeButtonPressedImg @"UIimages/easy2_p.png"
#define _NormalModeButtonImg @"UIimages/normal2.png"
#define _NormalModeButtonPressedImg @"UIimages/normal2_p.png"
#define _HardModeButtonImg @"UIimages/hard2.png"
#define _HardModeButtonPressedImg @"UIimages/hard2_p.png"
#define _FreeStyleModeButtonImg @"UIimages/free.png"
#define _FreeStyleModeButtonPressedImg @"UIimages/free_p.png"

#define _ReturnButtonImg @"UIimages/back_new.png"
#define _ReturnButtonPressedImg @"UIimages/back_new_p.png"

#define _ButtonPressedSound @"button_pressed.wav"
#define _MenuSelectedSound @"selected.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface PalModeMenuViewController (){
    bool _gameStarted;
    bool _soundOff;
}

@property (copy, nonatomic) NSString *mode;

@property (weak, nonatomic) IBOutlet PalMountainAndCloudView *bgAnimationView;
@property (strong, nonatomic) IBOutlet UIButton *easyButton;
@property (strong, nonatomic) IBOutlet UIButton *normalButton;
@property (strong, nonatomic) IBOutlet UIButton *hardButton;
@property (strong, nonatomic) IBOutlet UIButton *freeStyleButton;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIImageView *difChoice;

@end

@implementation PalModeMenuViewController



- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(_gameStarted) {

        _gameStarted = NO;
        if(!self.bgAnimationView.animationStarted) {
            [self.bgAnimationView setup];
            [self.bgAnimationView startAnimation];
        }
    }
    else {
        [PalMountainAndCloudView backgroundAnimation:self.view];
        if(!self.bgAnimationView.animationStarted) {
            [self.bgAnimationView setup];
            [self.bgAnimationView startAnimation];
        }
    }
    
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
    
    self.bgAnimationView.animationStarted = NO;
    
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        [self.difChoice setFrame:CGRectMake(40, 0, 240, 128)];
        
        [self.easyButton setFrame:CGRectMake(95, 120, 130, 65)];
        
        [self.normalButton setFrame:CGRectMake(95, 200, 130, 65)];
        
        [self.hardButton setFrame:CGRectMake(95, 280, 130, 65)];
        
        [self.freeStyleButton setFrame:CGRectMake(95, 360, 130, 65)];
        
        [self.returnButton setFrame:CGRectMake(250, 425, 50, 45)];
        
        [self.bgAnimationView setFrame:CGRectMake(0, 0, 320, 480)];
        

    }
    
    
    // set default images
    self.difChoice.image = [UIImage imageNamed:_ModeChoiceLabelImg];
    
    
    [self.easyButton setBackgroundImage:[UIImage imageNamed:_EasyModeButtonImg] forState:UIControlStateNormal];
    
    [self.easyButton setBackgroundImage:[UIImage imageNamed:_EasyModeButtonPressedImg] forState:UIControlStateHighlighted];

    [self.normalButton setBackgroundImage:[UIImage imageNamed:_NormalModeButtonImg] forState:UIControlStateNormal];
    
    [self.normalButton setBackgroundImage:[UIImage imageNamed:_NormalModeButtonPressedImg] forState:UIControlStateHighlighted];
    
    [self.hardButton setBackgroundImage:[UIImage imageNamed:_HardModeButtonImg] forState:UIControlStateNormal];
    
    [self.hardButton setBackgroundImage:[UIImage imageNamed:_HardModeButtonPressedImg] forState:UIControlStateHighlighted];
    
    [self.freeStyleButton setBackgroundImage:[UIImage imageNamed:_FreeStyleModeButtonImg] forState:UIControlStateNormal];
    
    [self.freeStyleButton setBackgroundImage:[UIImage imageNamed:_FreeStyleModeButtonPressedImg] forState:UIControlStateHighlighted];
    
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
        }
    }

    if (!_soundOff) {
        [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_MenuSelectedSound ofType:nil] forKey:@"selected"];
        [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_ButtonPressedSound ofType:nil] forKey:@"button"];
    }
    
    [self.bgAnimationView setup];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if (!_soundOff) {
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"MainBGM"];
        [player stop];
    }

    PalViewController *palVC = segue.destinationViewController;
    palVC.mode = self.mode;
    
    palVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    _gameStarted = YES;
    
}


- (IBAction)easyModeButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"selected"];
    }
    self.mode = @"easy";
}

- (IBAction)normalModeButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"selected"];
    }
    self.mode = @"normal";
}

- (IBAction)hardModeButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"selected"];
    }
    self.mode = @"hard";
}

- (IBAction)freeStyleModeButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"selected"];
    }
    self.mode = @"freeStyle";
}


- (IBAction)returnButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


- (void)viewDidUnload {
    [self setDifChoice:nil];
    [self setEasyButton:nil];
    [self setHardButton:nil];
    [self setNormalButton:nil];
    [self setFreeStyleButton:nil];
    [self setBgAnimationView:nil];
    [super viewDidUnload];
}
@end

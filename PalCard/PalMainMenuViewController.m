//
//  PalMainMenuViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-31.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalMainMenuViewController.h"
#import "PalModeMenuViewController.h"
#import "PalAchievementViewController.h"
#import "PalInstructionViewController.h"
#import "PalInformationViewController.h"
#import "PalMountainAndCloudView.h"
#import "PalDataInit.h"
#import "MCSoundBoard.h"

#define _LOGOPIC @"UIimages/main_logo.png"

#define _GameStartButtonImg @"UIimages/button_start.png"
#define _GameStartButtonPressedImg @"UIimages/button_start_p.png"
#define _AchievementButtonImg @"UIimages/button_lib.png"
#define _AchievementButtonPressedImg @"UIimages/button_lib_p.png"
#define _InstructionButtonImg @"UIimages/button_instruction.png"
#define _InstructionButtonPressedImg @"UIimages/button_instruction_p.png"
#define _InformationButtonImg @"UIimages/button_info.png"
#define _InformationButtonPressedImg @"UIimages/button_info_p.png"
#define _SoundOffImg @"UIimages/sound_off1.png"
#define _SoundOnImg @"UIimages/sound_on.png"

#define _DefaultCardImg @"palsource/888.png"

#define _ReturnButtonImg @"UIimages/back.png"
#define _ReturnButtonPressedImg @"UIimages/back_push.png"
#define _InfoBG @"UIimages/info_bg.png"
#define _NameTagImg @"UIimages/NameTag2.png"

#define _ButtonPressedSound @"button_pressed.wav"
#define _MenuSelectedSound @"selected.wav"

//#define _ThemeMusic @"main01.mp3"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface PalMainMenuViewController (){
    bool _soundOff;
}

@property (strong, nonatomic) IBOutlet UIImageView *blackBG;
@property (strong, nonatomic) IBOutlet UIImageView *soundSwitch;


@property (strong, nonatomic) IBOutlet UIButton *gameStartButton;
@property (strong, nonatomic) IBOutlet UIButton *achViewButton;
@property (strong, nonatomic) IBOutlet UIButton *instructionButton;
@property (strong, nonatomic) IBOutlet UIButton *informationButton;


@property (strong, nonatomic) IBOutlet PalMountainAndCloudView *bgAnimationView;

@property (strong, nonatomic) IBOutlet UIImageView *logoPic;


@end

@implementation PalMainMenuViewController


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
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.3];
    self.blackBG.alpha = 0.0f;
    [UIView commitAnimations];
    

}

- (void) viewWillAppear:(BOOL)animated
{
    // register for later use:
    // restart animation when game enter to foreground
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) restartAnimation{
    
    [self.bgAnimationView startAnimation];
    //NSLog(@"trigger event when will enter foreground.");
}

-(void) viewDidDisappear:(BOOL)animated{
    
    // unregister when view disappear
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self backgroundAnimation];
    [self.bgAnimationView startAnimation];

}   

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PalDataInit gameDataInit];
   
    NSString *turnOffSound = [[NSUserDefaults standardUserDefaults] valueForKey:@"turnOffSound"];
    
    if (turnOffSound) {
        
        if ([turnOffSound isEqualToString:@"YES"]) {
            _soundOff = YES;
            self.soundSwitch.image = [UIImage imageNamed:_SoundOffImg];
        }
        else if ([turnOffSound isEqualToString:@"NO"]) {
            _soundOff = NO;
            self.soundSwitch.image = [UIImage imageNamed:_SoundOnImg];
            
        }
    }
    
    //self.viewDeckController.panningMode = IIViewDeckNoPanning;
    //self.viewDeckController.leftSize = 100;
    //self.viewDeckController.openSlideAnimationDuration = 0.8f;
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.gameStartButton setFrame:CGRectMake(22, 210, 60, 180)];
        
        [self.achViewButton setFrame:CGRectMake(94, 245, 60, 180)];
        
        [self.instructionButton setFrame:CGRectMake(169, 210, 60, 180)];
        
        [self.informationButton setFrame:CGRectMake(242, 245, 60, 180)];
        
        [self.soundSwitch setFrame:CGRectMake(260, 430, 30, 30)];
        
        [self.bgAnimationView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    self.logoPic.image = [UIImage imageNamed:_LOGOPIC];
    
    // check whether user has turned off sound
    if (![MCSoundBoard audioPlayerForKey:@"MainBGM"] && !_soundOff)
    {
        [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1] ofType:nil] forKey:@"MainBGM"];
        
        [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_ButtonPressedSound ofType:nil] forKey:@"button"];
        
        
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"MainBGM"];
        
        player.numberOfLoops = -1;  // Endless
        [player play];
        [MCSoundBoard playAudioForKey:@"MainBGM" fadeInInterval:1.0];
    }
    
    
    // set default images for the buttons
    [self.gameStartButton setBackgroundImage:[UIImage imageNamed:_GameStartButtonImg] forState:UIControlStateNormal];
    
    [self.gameStartButton setBackgroundImage:[UIImage imageNamed:_GameStartButtonPressedImg] forState:UIControlStateHighlighted];
    
    [self.achViewButton setBackgroundImage:[UIImage imageNamed:_AchievementButtonImg] forState:UIControlStateNormal];
    
    [self.achViewButton setBackgroundImage:[UIImage imageNamed:_AchievementButtonPressedImg] forState:UIControlStateHighlighted];
    
    [self.instructionButton setBackgroundImage:[UIImage imageNamed:_InstructionButtonImg] forState:UIControlStateNormal];
    
    [self.instructionButton setBackgroundImage:[UIImage imageNamed:_InstructionButtonPressedImg] forState:UIControlStateHighlighted];
    
    [self.informationButton setBackgroundImage:[UIImage imageNamed:_InformationButtonImg] forState:UIControlStateNormal];
    
    [self.informationButton setBackgroundImage:[UIImage imageNamed:_InformationButtonPressedImg] forState:UIControlStateHighlighted];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gameStartButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    
    PalModeMenuViewController *modeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainGameSegue"];
    [self presentViewController:modeVC animated:NO completion:nil];
    
}

- (IBAction)achievementButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    PalAchievementViewController *achVC = [self.storyboard instantiateViewControllerWithIdentifier:@"achRootSegue"];
    
    [self presentViewController:achVC animated:NO completion:nil];

}

- (IBAction)instructionButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    PalInstructionViewController *insVC = [self.storyboard instantiateViewControllerWithIdentifier:@"instructionSegue"];
    
    [self presentViewController:insVC animated:NO completion:nil];

}

- (IBAction)informationButtonPressed:(UIButton *)sender {
    
    if (!_soundOff) {
        [MCSoundBoard playSoundForKey:@"button"];
    }
    PalInformationViewController *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"informationSegue"];
    
    [self presentViewController:infoVC animated:NO completion:nil];

}



- (IBAction)soundOnOffButtonPressed:(UITapGestureRecognizer *)sender {
    
    if (_soundOff) {
        
        _soundOff = NO;
        self.soundSwitch.image = [UIImage imageNamed:_SoundOnImg];
        
        NSString *sound = [NSString stringWithFormat:@"NO"];
        [[NSUserDefaults standardUserDefaults] setValue:sound forKey:@"turnOffSound"];
        
        if (![MCSoundBoard audioPlayerForKey:@"MainBGM"])
        {
            [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1] ofType:nil] forKey:@"MainBGM"];
        }
        
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"MainBGM"];
        
        player.numberOfLoops = -1;  // Endless
        [player play];
        [MCSoundBoard playAudioForKey:@"MainBGM" fadeInInterval:1.0];
        
    }
    else {
        _soundOff = YES;
        self.soundSwitch.image = [UIImage imageNamed:_SoundOffImg];
        
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"MainBGM"];
        [player stop];
        
        NSString *sound = [NSString stringWithFormat:@"YES"];
        [[NSUserDefaults standardUserDefaults] setValue:sound forKey:@"turnOffSound"];
    }
}

- (void)viewDidUnload {
    [self setBgAnimationView:nil];
    [super viewDidUnload];
}
@end

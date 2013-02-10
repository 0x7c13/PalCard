//
//  PalViewController.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-28.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalViewController.h"
#import "MCSoundBoard.h"
#import "PalCardGenerator.h"
#import "PalAchievementBrain.h"

#import <QuartzCore/QuartzCore.h>

#define _ANITIME_LONG 0.4
#define _ANITIME_SHORT 0.3
#define _AMOUNT_OF_CARDS 12

#define _BGPIC "palsource/888.png"
#define _GameBG "palsource/bg4_R.jpg"

#define _GameLoseImg "UIimages/fal.png"
#define _GameWinImg "UIimages/suc.png"

#define _ThemeMusic "main01.mp3"
#define _GameLoseSound "los.wav"
#define _GameWinSound "win.wav"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


@interface PalViewController (){
    bool _cardIsVisiable[_AMOUNT_OF_CARDS + 1];
    bool _isBlackCard[_AMOUNT_OF_CARDS + 1];
    bool _animating;
    bool _gameOver;
    bool _soundOff;
    int _flag;
    int _lastCardNumber;
    int _currentCardNumber;
    float _roundTime;
    float _totalTime;
    float _watchTime;
    
    // achievement
    bool _endWithBlack;
    int _rights;
    int _wrongs;
    
}

@property (weak, nonatomic) IBOutlet UILabel *TextDisplay;
@property (weak, nonatomic) IBOutlet UILabel *Display;

@property (strong, nonatomic) IBOutlet UIProgressView *gameProgress;


@property (strong, nonatomic) IBOutlet UIImageView *PalCardView1;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView2;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView3;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView4;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView5;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView6;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView7;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView8;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView9;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView10;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView11;
@property (strong, nonatomic) IBOutlet UIImageView *PalCardView12;


@property (strong, nonatomic) IBOutlet UIImageView *DefaultView1;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView2;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView3;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView4;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView5;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView6;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView7;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView8;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView9;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView10;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView11;
@property (strong, nonatomic) IBOutlet UIImageView *DefaultView12;
@property (strong, nonatomic) IBOutlet UIImageView *MainGameBG;


@property (strong, nonatomic) IBOutlet UIView *Card1;
@property (strong, nonatomic) IBOutlet UIView *Card2;
@property (strong, nonatomic) IBOutlet UIView *Card3;
@property (strong, nonatomic) IBOutlet UIView *Card4;
@property (strong, nonatomic) IBOutlet UIView *Card5;
@property (strong, nonatomic) IBOutlet UIView *Card6;
@property (strong, nonatomic) IBOutlet UIView *Card7;
@property (strong, nonatomic) IBOutlet UIView *Card8;
@property (strong, nonatomic) IBOutlet UIView *Card9;
@property (strong, nonatomic) IBOutlet UIView *Card10;
@property (strong, nonatomic) IBOutlet UIView *Card11;
@property (strong, nonatomic) IBOutlet UIView *Card12;








@property (weak, nonatomic) UIImageView *LastView;
@property (weak, nonatomic) UIImageView *LastDefault;
@property (weak, nonatomic) UIImageView *CurrentView;
@property (weak, nonatomic) UIImageView *CurrentDefault;

// right card animation tmp views
@property (weak, nonatomic) UIImageView *fView;
@property (weak, nonatomic) UIImageView *sView;

@property (strong) NSArray *cardViews;
@property (strong) NSArray *defaultViews;

@end 

@implementation PalViewController


#pragma mark  alert  delegate 


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        
        [self cardsInvisiable];
    
        [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(nextRound:) userInfo:nil repeats: NO];
    }
    else {
        _gameOver = 1;
        
        if (!_soundOff) {
            
        
            [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:@_ThemeMusic ofType:nil] forKey:@"MainBGM"];
        
            AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"MainBGM"];
        
            player.numberOfLoops = -1;  // Endless
            [player play];
            [MCSoundBoard playAudioForKey:@"MainBGM" fadeInInterval:1.0];
        }
        
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}



#pragma mark -------

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    // hide navigation bar
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark cards animation

// flip effect
- (void)flipActionWithFirst:(UIImageView *)firstView
                  andSecond:(UIImageView *)secondView
{
    [UIView transitionFromView:firstView toView:secondView duration:_ANITIME_LONG options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    [UIView commitAnimations];
}


- (void)cardsVisiable
{
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i++){
        
        if (!_cardIsVisiable[i]) {
            [self flipActionWithFirst:[self.defaultViews objectAtIndex:(i - 1)] andSecond:   [self.cardViews objectAtIndex:(i - 1)]];
        }
    }
}

- (void)cardsInvisiable
{
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i++){
        
        if (_cardIsVisiable[i]) {
            [self flipActionWithFirst:[self.cardViews objectAtIndex:(i - 1)] andSecond:   [self.defaultViews objectAtIndex:(i - 1)]];
        }
    }
}

// add shadow to the given view
- (void)addShadow: (UIImageView *)view
{
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowOffset:CGSizeMake(5, 5)];
    [view.layer setShadowOpacity:0.3];
    [view.layer setShadowRadius:6.0];
}


/*
 -(UIImage*)getGrayImage:(UIImage*)sourceImage
 {
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
 
    if (context == NULL) {
        return nil;
    }
 
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
 
    return grayImage;
 }
 
 
 
 - (void)addBlackCard
 {
    int blackCard= arc4random() % _AMOUNT_OF_CARDS;
 
    while (_isBlackCard[blackCard + 1]) blackCard = arc4random() % _AMOUNT_OF_CARDS;
 
    UIImageView *first = [self.cardViews objectAtIndex:blackCard];
    UIImageView *second;
 
    _isBlackCard[blackCard + 1] = YES;
 
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++) {
 
        second = [self.cardViews objectAtIndex:i];
 
        if (first.image == second.image && blackCard != i) {
 
            _isBlackCard[i + 1] = YES;
            break;
        }
    }
 
    first.image = [self getGrayImage:first.image];
    second.image = [self getGrayImage:second.image];
 
 }
 
 */

- (void)rightCardAnimation: (NSTimer *) timer
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t,-t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity,-t, t);
    
    self.fView.transform = leftQuake;  // starting point
    self.sView.transform = leftQuake;
    
    [UIView beginAnimations:@"earthquake" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];    // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.07];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    self.fView.transform = rightQuake;    // end here & auto-reverse
    self.sView.transform = rightQuake;
    
    [UIView commitAnimations];
    
}


- (void) wrongCardAnimation: (NSTimer *) timer
{
    /*
     NSMutableArray *ary = [[NSMutableArray alloc]init];
     
     [ary addObject:[UIImage imageNamed:@"020.png"]];
     [ary addObject:[UIImage imageNamed:@"999.png"]];
     
     [FirstView setImage:[UIImage imageNamed:@"999.png"]];
     [SecondView setImage:[UIImage imageNamed:@"999.png"]];
     
     FirstView.animationImages = ary;
     FirstView.animationDuration = 1;
     FirstView.animationRepeatCount = 1;
     
     SecondView.animationImages = ary;
     SecondView.animationDuration = 1;
     SecondView.animationRepeatCount = 1;
     
     [FirstView startAnimating];
     [SecondView startAnimating];
     */
    
    
    _animating = YES;
    
    [UIView transitionFromView:self.LastView toView:self.LastDefault duration:_ANITIME_SHORT options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    [UIView transitionFromView:self.CurrentView toView:self.CurrentDefault duration:_ANITIME_SHORT options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
    
    [UIView commitAnimations];
    
    
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_SHORT target:self selector:@selector(ArrowAnimationPlay:) userInfo:nil repeats: NO];
    
}





#pragma mark -------

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.Card1 setFrame:CGRectMake(30, 3, 78, 110)];
        [self.Card2 setFrame:CGRectMake(121, 3, 78, 110)];
        [self.Card3 setFrame:CGRectMake(212, 3, 78, 110)];
        
        [self.Card4 setFrame:CGRectMake(30, 116, 78, 110)];
        [self.Card5 setFrame:CGRectMake(121, 116, 78, 110)];
        [self.Card6 setFrame:CGRectMake(212, 116, 78, 110)];
        
        [self.Card7 setFrame:CGRectMake(30, 229, 78, 110)];
        [self.Card8 setFrame:CGRectMake(121, 229, 78, 110)];
        [self.Card9 setFrame:CGRectMake(212, 229, 78, 110)];
        
        [self.Card10 setFrame:CGRectMake(30, 342, 78, 110)];
        [self.Card11 setFrame:CGRectMake(121, 342, 78, 110)];
        [self.Card12 setFrame:CGRectMake(212, 342, 78, 110)];
        
        [self.TextDisplay setFrame:CGRectMake(59, 450, 202, 31)];
        
        [self.Display setFrame:CGRectMake(200, 450, 60, 31)];
        
        [self.Display setFont:[UIFont fontWithName:@"DuanNing-XIng" size:20]];
        [self.TextDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:20]];
        
        [self.gameProgress setFrame:CGRectMake(25, 460, 270, 9) ];

    }
    else {
        [self.Display setFont:[UIFont fontWithName:@"DuanNing-XIng" size:25]];
        [self.TextDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:25]];
    }
    
    
    // check whether user has turned off sound
    NSString *turnOffSound = [[NSUserDefaults standardUserDefaults] valueForKey:@"turnOffSound"];
    
    if (turnOffSound) {
        
        if ([turnOffSound isEqualToString:@"YES"]) {
            _soundOff = YES;
        }
        else if ([turnOffSound isEqualToString:@"NO"]) {
            _soundOff = NO;
            
            NSString *gameBGM = [[NSString alloc]init];
            gameBGM = [NSString stringWithFormat:@"zd0%d.mp3", arc4random() % 6 + 1 ];
            
            [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:gameBGM ofType:nil]     forKey:@"BGM"];
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:@_GameLoseSound ofType:nil] forKey:@"LOS"];
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:@_GameWinSound ofType:nil] forKey:@"WIN"];
        }
    }

    
    [self gameInitilize];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)gameInitilize
{
    // hide all cards
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i++) {
        _cardIsVisiable[i] = NO;
        _isBlackCard[i] = NO;
    }
    
    self.MainGameBG.image = [UIImage imageNamed:@_GameBG];
    
    if (!_soundOff) {
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"BGM"];
    
        player.numberOfLoops = -1;  // Endless
        [player play];
        [MCSoundBoard playAudioForKey:@"BGM" fadeInInterval:1.0];
    }
    
    // use PalCardGenerator to generate images of 12 cards
    PalCardGenerator *cardGenerator = [[PalCardGenerator alloc]init];
    
    
    self.cardViews = [NSArray arrayWithObjects:self.PalCardView1, self.PalCardView2, self.PalCardView3, self.PalCardView4, self.PalCardView5, self.PalCardView6, self.PalCardView7, self.PalCardView8, self.PalCardView9, self.PalCardView10, self.PalCardView11, self.PalCardView12, nil];
    
    self.defaultViews = [NSArray arrayWithObjects:self.DefaultView1, self.DefaultView2, self.DefaultView3, self.DefaultView4, self.DefaultView5, self.DefaultView6, self.DefaultView7, self.DefaultView8, self.DefaultView9, self.DefaultView10, self.DefaultView11, self.DefaultView12 , nil];
    
    
    // mode settings
    
    if ([self.mode isEqualToString:@"easy"]) {
        cardGenerator.NumbersOfBlackCards = 0;
    }
    else if ([self.mode isEqualToString:@"normal"]) {
        cardGenerator.NumbersOfBlackCards = 1;
    }
    else if ([self.mode isEqualToString:@"hard"]) {
        cardGenerator.NumbersOfBlackCards = 2;
    }
    
    // black cards settings
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++) {
        
        UIImageView *tmp;
        tmp = [self.cardViews objectAtIndex:i];
        tmp.image = [UIImage imageNamed:cardGenerator.getACardWithPath];
        
        if ([[cardGenerator lastIsBlackOrNot] isEqualToString:@"YES"]) {
            _isBlackCard[i + 1] = YES;

        }
        
        [self addShadow:tmp];
        
        tmp = [self.defaultViews objectAtIndex:i];
        tmp.image = [UIImage imageNamed:@_BGPIC];
        [self addShadow:tmp];
        
    }
    
    // set default values
    
    self.Display.text = @"";
    
    _gameOver = NO;
    _flag = 0;
    _lastCardNumber = 0;
    _currentCardNumber = 0;
    
    _endWithBlack = NO;
    _rights = 0;
    _wrongs = 0;
    
    // 根据难度模式 设置游戏时间
    
    if ([self.mode isEqualToString:@"easy"]) {
        _totalTime = 15.0;
        _watchTime = 1.5;
    }
    else if ([self.mode isEqualToString:@"normal"]) {
        _totalTime = 15.0;
        _watchTime = 1.2;
    }
    else if ([self.mode isEqualToString:@"hard"]) {
        _totalTime = 15.0;
        _watchTime = 1.0;
    }
        
    _roundTime = _totalTime;
    
    
    /*
    if ([self.mode isEqualToString:@"normal"]) {
        [self addBlackCard];
    }
    else if ([self.mode isEqualToString:@"hard"]) {
        [self addBlackCard];
        [self addBlackCard];
        
    }
     */
    
    _animating = YES;
    
    
    self.TextDisplay.text = @"游戏马上开始";
    
    // preparation time before game started
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG + 1 target:self selector:@selector(prepare:) userInfo:nil repeats: NO];
    
    // preparation finished
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG + 1 + _watchTime target:self selector:@selector(prepareDone:) userInfo:nil repeats: NO];
    
}

- (void)prepare:(NSTimer *) timer
{
    [self cardsVisiable];
    self.TextDisplay.text = @"请记忆卡牌位置";
}

- (void)prepareDone:(NSTimer *) timer
{
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i++) _cardIsVisiable[i] = YES;
    [self cardsInvisiable]; // 翻回所有卡牌
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(startTimer:) userInfo:nil repeats: NO];
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i++) _cardIsVisiable[i] = NO;
}




#pragma mark Game Timer

- (void)startTimer:(NSTimer *) timer
{
    self.gameProgress.alpha = 1.0;
    
    _animating = NO;
    
    if (DEVICE_IS_IPHONE5) {
        self.TextDisplay.text = @"剩余时间";
        self.Display.text = @"15 秒";
    }
    else {
        self.TextDisplay.text = @"";
        self.Display.text = @"";
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(GameTimer:) userInfo:nil repeats: YES];
    
    //[NSTimer scheduledTimerWithTimeInterval: 15 target:self selector:@selector(GameOver:) userInfo:nil repeats: NO];
}

- (void)GameTimer:(NSTimer *) timer
{
    if (!_gameOver) {
        
        _roundTime -= 0.1;
        self.gameProgress.progress = (float)_roundTime / _totalTime;
        
        if (DEVICE_IS_IPHONE5) {
            self.Display.text = [NSString stringWithFormat:@"%.0f 秒", _roundTime + 0.5];
        }
        
        if (_roundTime <= 0.0) {
            
            [timer invalidate];
            [self gameFinish];
        }
    }
    else {
        [timer invalidate];
    }
}





#pragma mark ------- win and lose


// check whether user win the game 

- (bool) win
{
    for (int i = 1; i <= _AMOUNT_OF_CARDS; i ++) {
        if (!_cardIsVisiable[i] && !_isBlackCard[i]) return NO;
    }
    
    if (_gameOver) return NO;
    
    _gameOver = YES;
    
    self.gameProgress.alpha = 0.0;
    
    if([PalAchievementBrain newAchievementUnlocked:self.mode winOrLose:YES timeRemain:15 - _roundTime wrongsTimes:_wrongs rightTimes:_rights endWithBlackOrNot:_endWithBlack])
    {
        self.TextDisplay.text = @"新卡牌解锁！";
    }
    else {
        self.TextDisplay.text = @"游戏结束";
    }
    
    
    if (!_soundOff) {
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"BGM"];
        if (player.playing) {
            [MCSoundBoard pauseAudioForKey:@"BGM" fadeOutInterval:0.0];
        } else {
            [MCSoundBoard playAudioForKey:@"BGM" fadeInInterval:0.0];
        }
        
        [MCSoundBoard playSoundForKey:@"WIN"];
    }
    
    self.Display.text = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n\n\n" message:@"\n\n\n" delegate:self cancelButtonTitle:@"重新开始" otherButtonTitles:@"返回",nil];
    [alert show];
    
    UIImageView *imgv = [alert valueForKey:@"_backgroundImageView"];
    imgv.image = [UIImage imageNamed:@_GameWinImg];
    
    return YES;
}


- (void)gameFinish
{
    _gameOver = YES;
    
    self.gameProgress.alpha = 0.0;
    
    if (!_soundOff) {
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"BGM"];
        if (player.playing) {
            [MCSoundBoard pauseAudioForKey:@"BGM" fadeOutInterval:0.0];
        } else {
            [MCSoundBoard playAudioForKey:@"BGM" fadeInInterval:0.0];
        }
        [MCSoundBoard playSoundForKey:@"LOS"];
    }
    
    // check whether new achievement unlocked
    if([PalAchievementBrain newAchievementUnlocked:self.mode winOrLose:NO timeRemain:_totalTime - _roundTime wrongsTimes:_wrongs rightTimes:_rights endWithBlackOrNot:_endWithBlack])
    {
        self.TextDisplay.text = @"新卡牌解锁！";
    }
    else {
        self.TextDisplay.text = @"游戏结束";
    }
    
    self.Display.text = @"";

    
    // call alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n\n\n" message:@"\n\n\n" delegate:self cancelButtonTitle:@"重新开始" otherButtonTitles:@"返回",nil];
    [alert show];
    
    UIImageView *imgv = [alert valueForKey:@"_backgroundImageView"];
    imgv.image = [UIImage imageNamed:@_GameLoseImg];
}


- (void)ArrowAnimationPlay:(NSTimer *) timer
{
    _animating = NO;
}


- (void)nextRound:(NSTimer *) timer
{
    [self gameInitilize];
}





- (void)CardDecision:(NSTimer *) timer
{
    if (_flag == 2) {
        
        if (self.LastView.image != self.CurrentView.image) {
        
            _cardIsVisiable[_lastCardNumber] = NO;
            _cardIsVisiable[_currentCardNumber] = NO;
            
            _wrongs ++;
            [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(wrongCardAnimation:) userInfo:nil repeats: NO];
        }
        else {
            
            _cardIsVisiable[_lastCardNumber] = YES;
            _cardIsVisiable[_currentCardNumber] = YES;
            
            _rights ++;
            
            self.fView = self.CurrentView;
            self.sView = self.LastView;
            
            [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(rightCardAnimation:) userInfo:nil repeats: NO];
            
            [self win];
            _animating = NO;
        }
        
        _flag = 0;
        _lastCardNumber = 0;
    }
    else {
        _animating = NO;
    }
}



- (void)processWithCardView:(UIImageView *)cardImage
                defaultView:(UIImageView *)defaultImage
                 cardNumber:(int )number
{
    
    if (!_animating && !_gameOver && !_cardIsVisiable[number]) {
        
        _flag ++;
        
        _animating = YES;
        
        [UIView transitionFromView:defaultImage toView:cardImage duration:_ANITIME_LONG options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
        
        [UIView commitAnimations];
        
        _cardIsVisiable[number] = YES;
        
        if (_isBlackCard[number]) {
            
            _endWithBlack = YES;
            [self gameFinish];
            return ;
        }
        
        
        if (_flag == 1) {
            self.LastView = cardImage;
            self.LastDefault = defaultImage;
            _lastCardNumber = number;
        }
        else if (_flag == 2) {
            self.CurrentView = cardImage;
            self.CurrentDefault = defaultImage;
            _currentCardNumber = number;
        }
        
        //[NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(CardDecision:) userInfo:nil repeats: NO];
        [self CardDecision:nil];
    }

}



- (IBAction)Card1Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView1 defaultView:self.DefaultView1 cardNumber:1];
}

- (IBAction)Card2Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView2 defaultView:self.DefaultView2 cardNumber:2];
}

- (IBAction)Card3Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView3 defaultView:self.DefaultView3 cardNumber:3];
}

- (IBAction)Card4Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView4 defaultView:self.DefaultView4 cardNumber:4];
}

- (IBAction)Card5Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView5 defaultView:self.DefaultView5 cardNumber:5];
}

- (IBAction)Card6Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView6 defaultView:self.DefaultView6 cardNumber:6];
}

- (IBAction)Card7Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView7 defaultView:self.DefaultView7 cardNumber:7];
}

- (IBAction)Card8Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView8 defaultView:self.DefaultView8 cardNumber:8];
}

- (IBAction)Card9Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView9 defaultView:self.DefaultView9 cardNumber:9];
}

- (IBAction)Card10Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView10 defaultView:self.DefaultView10 cardNumber:10];
}


- (IBAction)Card11Pressed:(UITapGestureRecognizer *)sender {

    [self processWithCardView:self.PalCardView11 defaultView:self.DefaultView11 cardNumber:11];
}

- (IBAction)Card12Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardView:self.PalCardView12 defaultView:self.DefaultView12 cardNumber:12];
}



@end

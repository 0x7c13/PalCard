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
#import "PalCard.h"

#import <QuartzCore/QuartzCore.h>

#define _ANITIME_LONG 0.4
#define _ANITIME_SHORT 0.3
#define _AMOUNT_OF_CARDS 12

#define _BGPIC @"palsource/888.png"
#define _GameBG @"palsource/bg4_R.jpg"

#define _GameLoseImg @"UIimages/fal.png"
#define _GameWinImg @"UIimages/suc.png"


#define _GameLoseSound @"los.wav"
#define _GameWinSound @"win.wav"

#define _HintPrepareIMG @"UIimages/ready.png"
#define _HintStartIMG @"UIimages/go.png"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


@interface PalViewController (){
    
    bool _wrongAnimating;
    bool _gameOver;
    bool _soundOff;
    bool _gameStarted;
    
    int _flag;
    int _numberOfFinishedCards;
    int _numberOfBlackCards;
    
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

@property (weak, nonatomic) IBOutlet UIProgressView *gameProgress;

@property (strong, nonatomic) IBOutlet UIImageView *MainGameBG;


@property (strong, nonatomic) IBOutlet PalCard *Card1;
@property (strong, nonatomic) IBOutlet PalCard *Card2;
@property (strong, nonatomic) IBOutlet PalCard *Card3;
@property (strong, nonatomic) IBOutlet PalCard *Card4;
@property (strong, nonatomic) IBOutlet PalCard *Card5;
@property (strong, nonatomic) IBOutlet PalCard *Card6;
@property (strong, nonatomic) IBOutlet PalCard *Card7;
@property (strong, nonatomic) IBOutlet PalCard *Card8;
@property (strong, nonatomic) IBOutlet PalCard *Card9;
@property (strong, nonatomic) IBOutlet PalCard *Card10;
@property (strong, nonatomic) IBOutlet PalCard *Card11;
@property (strong, nonatomic) IBOutlet PalCard *Card12;

@property (strong, nonatomic) IBOutlet UIImageView *hintView;

@property (weak, nonatomic) PalCard *LastCard;
@property (weak, nonatomic) PalCard *CurrentCard;


@property (strong, nonatomic) NSArray *palCards;


@end 

@implementation PalViewController





#pragma mark -------

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    // hide navigation bar
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -------


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // I use storyboard to design UI for iphone 5
    // here are frame tweaks for iPhone 4/4S
    if (!DEVICE_IS_IPHONE5) {
        
        [self.Card1 setFrame:CGRectMake(33, 5, 74, 104)];
        
        [self.Card2 setFrame:CGRectMake(123, 5, 74, 104)];
        
        [self.Card3 setFrame:CGRectMake(213, 5, 74, 104)];
        
        [self.Card4 setFrame:CGRectMake(33, 118, 74, 104)];
        
        [self.Card5 setFrame:CGRectMake(123, 118, 74, 104)];
        
        [self.Card6 setFrame:CGRectMake(213, 118, 74, 104)];
        
        [self.Card7 setFrame:CGRectMake(33, 231, 74, 104)];
        
        [self.Card8 setFrame:CGRectMake(123, 231, 74, 104)];
        
        [self.Card9 setFrame:CGRectMake(213, 231, 74, 104)];
        
        [self.Card10 setFrame:CGRectMake(33, 344, 74, 104)];
        
        [self.Card11 setFrame:CGRectMake(123, 344, 74, 104)];
        
        [self.Card12 setFrame:CGRectMake(213, 344, 74, 104)];
        
        [self.TextDisplay setFrame:CGRectMake(59, 450, 202, 31)];
        
        [self.Display setFrame:CGRectMake(200, 450, 60, 31)];
        
        [self.gameProgress setFrame:CGRectMake(25, 460, 270, 9) ];
        
        [self.hintView setFrame:CGRectMake(35, 125, 250, 200) ];
        
        [self.Display setFont:[UIFont fontWithName:@"DuanNing-XIng" size:20]];
        [self.TextDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:20]];

    }
    else {
        [self.Display setFont:[UIFont fontWithName:@"DuanNing-XIng" size:25]];
        [self.TextDisplay setFont:[UIFont fontWithName:@"DuanNing-XIng" size:25]];
    }
    
    // set images
    self.MainGameBG.image = [UIImage imageNamed:_GameBG];
    
    // check whether user has turned off sound
    NSString *turnOffSound = [[NSUserDefaults standardUserDefaults] valueForKey:@"turnOffSound"];
    
    if (turnOffSound) {
        
        if ([turnOffSound isEqualToString:@"YES"]) {
            _soundOff = YES;
        }
        else if ([turnOffSound isEqualToString:@"NO"]) {
            _soundOff = NO;
            
            NSString *gameBGM;
            gameBGM = [NSString stringWithFormat:@"zd0%d.mp3", arc4random() % 6 + 1 ];
            
            [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:gameBGM ofType:nil]     forKey:@"BGM"];
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_GameLoseSound ofType:nil] forKey:@"LOS"];
            [MCSoundBoard addSoundAtPath:[[NSBundle mainBundle] pathForResource:_GameWinSound ofType:nil] forKey:@"WIN"];
        }
    }
    
    
    self.palCards = [NSArray arrayWithObjects:self.Card1, self.Card2, self.Card3, self.Card4, self.Card5, self.Card6, self.Card7, self.Card8, self.Card9, self.Card10, self.Card11, self.Card12, nil];
    
    [self gameInitilize];

}


- (void)gameInitilize
{
    // set default values
    self.Display.text = @"";
    
    _gameStarted = NO;
    _wrongAnimating = NO;
    _gameOver = NO;
    _flag = 0;
    _numberOfFinishedCards = 0;
    
    _endWithBlack = NO;
    _rights = 0;
    _wrongs = 0;
    
    
    // play BGM
    if (!_soundOff) {
        AVAudioPlayer *player = [MCSoundBoard audioPlayerForKey:@"BGM"];
    
        player.numberOfLoops = -1;  // Endless
        [player play];
        [MCSoundBoard playAudioForKey:@"BGM" fadeInInterval:1.0];
    }
    
    // use PalCardGenerator to generate images of 12 cards
    PalCardGenerator *cardGenerator = [[PalCardGenerator alloc]init];
    
    // mode settings
    if ([self.mode isEqualToString:@"easy"] || [self.mode isEqualToString:@"freeStyle"]) {
        cardGenerator.NumbersOfBlackCards = 0;
    }
    else if ([self.mode isEqualToString:@"normal"]) {
        cardGenerator.NumbersOfBlackCards = 1;
    }
    else if ([self.mode isEqualToString:@"hard"]) {
        cardGenerator.NumbersOfBlackCards = 2;
    }
    
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++) {
        
        PalCard *tmp = self.palCards[i];
        
        [tmp setImageWithPath:[NSString stringWithString:cardGenerator.getACardWithPath]];
        
        if ([[cardGenerator lastIsBlack] isEqualToString:@"YES"]) {
            tmp.isBlackCard = YES;
        }
        tmp.cardNumber = i;
        tmp.originFrame = tmp.frame;
    }
    
    
    // Time setting
    if ([self.mode isEqualToString:@"easy"]) {
        _totalTime = 15.0;
        _watchTime = 1.5;
        _numberOfBlackCards = 0;
    }
    else if ([self.mode isEqualToString:@"normal"]) {
        _totalTime = 13.0;
        _watchTime = 1.2;
        _numberOfBlackCards = 2;
    }
    else if ([self.mode isEqualToString:@"hard"]) {
        _totalTime = 10.0;
        _watchTime = 1.0;
        _numberOfBlackCards = 4;
    }
    else if ([self.mode isEqualToString:@"freeStyle"]) {
        _totalTime = 20.0;
        _watchTime = 0.0;
        _numberOfBlackCards = 0;
    }
        
    _roundTime = _totalTime;
    
    
    
    // prepare for begin
    self.TextDisplay.text = @"游戏马上开始";
    
    self.hintView.image = [UIImage imageNamed:_HintPrepareIMG];
    self.hintView.alpha = 1.0;
    
    [UIView animateWithDuration:1.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.hintView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         self.hintView.image = [UIImage imageNamed:_HintStartIMG];
                         [UIView animateWithDuration:0.5
                                               delay: _watchTime
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.hintView.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              self.hintView.alpha = 0.0;
                                              _gameStarted = YES;
                                          }];
                     }];
    
    
    // preparation time before game started
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG + 1 target:self selector:@selector(prepare:) userInfo:nil repeats: NO];
    
    // preparation finished
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG + 1 + _watchTime target:self selector:@selector(prepareDone:) userInfo:nil repeats: NO];
    
}

- (void)prepare:(NSTimer *) timer
{
    [self cardsVisiableWithDuration:_ANITIME_LONG];
    self.TextDisplay.text = @"请记忆卡牌位置";
}

- (void)prepareDone:(NSTimer *) timer
{

    [self cardsInvisiableWithDuration:_ANITIME_LONG]; // 翻回所有卡牌
    
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(startTimer:) userInfo:nil repeats: NO];
    
}




#pragma mark Game Timer

- (void)startTimer:(NSTimer *) timer
{
    
    self.gameProgress.alpha = 1.0;
    
    if (DEVICE_IS_IPHONE5) {
        self.TextDisplay.text = @"剩余时间";
        self.Display.text = @"15 秒";
    }
    else {
        self.TextDisplay.text = @"";
        self.Display.text = @"";
    }
    
    [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self selector:@selector(GameTimer:) userInfo:nil repeats: YES];

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






#pragma mark ------- game brain


// check whether user win the game 

- (bool) win
{
    if (_gameOver) return NO;
    
    _gameOver = YES;
    
    self.gameProgress.alpha = 0.0;
    
    
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
    imgv.image = [UIImage imageNamed:_GameWinImg];
    
    
    if([PalAchievementBrain newAchievementUnlocked:self.mode win:YES timeUsed:_totalTime - _roundTime timeLeft:_roundTime wrongsTimes:_wrongs rightTimes:_rights endWithBlackOrNot:_endWithBlack])
    {
        self.TextDisplay.text = @"新卡牌解锁！";
    }
    else {
        self.TextDisplay.text = @"游戏结束";
    }
    
    
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
    
    
    // call alert
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\n\n\n" message:@"\n\n\n" delegate:self cancelButtonTitle:@"重新开始" otherButtonTitles:@"返回",nil];
    [alert show];
    
    UIImageView *imgv = [alert valueForKey:@"_backgroundImageView"];
    imgv.image = [UIImage imageNamed:_GameLoseImg];
    
    
    // check whether new achievement unlocked
    if([PalAchievementBrain newAchievementUnlocked:self.mode win:NO timeUsed:_totalTime - _roundTime timeLeft:_roundTime wrongsTimes:_wrongs rightTimes:_rights endWithBlackOrNot:_endWithBlack])
    {
        self.TextDisplay.text = @"新卡牌解锁！";
    }
    else {
        self.TextDisplay.text = @"游戏结束";
    }
    
    self.Display.text = @"";
}


- (void)nextRound:(NSTimer *) timer
{
    [self gameInitilize];
}


- (void)CardDecision
{
        
    if (![self.LastCard.cardName isEqualToString:self.CurrentCard.cardName]) {
            
        _wrongs ++;
        _wrongAnimating = YES;
        [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(wrongCardAnimation:) userInfo:nil repeats: NO];
    }
    else {
        
        _rights ++;
        _numberOfFinishedCards += 2;
        
        NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
        [myDictionary setObject:self.CurrentCard forKey:@"fCard"];
        [myDictionary setObject:self.LastCard forKey:@"sCard"];
        
        [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(rightCardAnimation:) userInfo:myDictionary repeats: NO];
        
        myDictionary = nil;
            
        if (_numberOfFinishedCards == _AMOUNT_OF_CARDS - _numberOfBlackCards) {
            [self win];
        }
    }
        
    _flag = 0;

}


- (void)processWithCardNumber:(int )index
{
    
    PalCard *card = self.palCards[index - 1];
    
    if (!card.isAnimating && !card.isVisiable && !card.isDisappear
            && !_wrongAnimating && !_gameOver && _gameStarted) {
        
        _flag ++;
        
        [card flipWithDuration:_ANITIME_LONG];
        
        
        if (card.isBlackCard) {
            
            _endWithBlack = YES;
            [self gameFinish];
            return ;
        }
        
        if (_flag == 1) {
            self.LastCard = card;
        }
        else if (_flag == 2) {
            self.CurrentCard = card;
        }

        if (_flag == 2) [self CardDecision];
    }

}




#pragma mark cards animation


- (void) cardsVisiableWithDuration: (NSTimeInterval) animationTime
{
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++){
        
        PalCard *tmp = [self.palCards objectAtIndex:i];
        if(!tmp.isVisiable) {
            [tmp flipWithDuration:animationTime];
        }
    }
}

- (void) cardsInvisiableWithDuration: (NSTimeInterval) animationTime
{
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++){
        
        PalCard *tmp = [self.palCards objectAtIndex:i];
        if(tmp.isVisiable) {
            [tmp flipWithDuration:animationTime];
        }
    }
}

- (void) cardsDisappear
{
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++){
        
        PalCard *tmp = [self.palCards objectAtIndex:i];
        if(!tmp.isDisappear) {
            [tmp disappearWithDuration:0.0];
        }
    }

}

- (void) cardsMoveToOrigin
{
    for (int i = 0; i < _AMOUNT_OF_CARDS; i++){
        
        PalCard *tmp = [self.palCards objectAtIndex:i];
        tmp.frame = tmp.originFrame;
    }
}



- (void)rightCardAnimation: (NSTimer *) timer
{
    PalCard *fCard = [[timer userInfo] objectForKey:@"fCard"];
    PalCard *sCard = [[timer userInfo] objectForKey:@"sCard"];
    
    
    if (![self.mode isEqualToString:@"hard"]) {
        
        [fCard shakeWithDuration:0.07f];
        [sCard shakeWithDuration:0.07f];
    }
    else {
            if (fCard.cardNumber > sCard.cardNumber) {
                PalCard *tmp = fCard;
                fCard = sCard;
                sCard = tmp;
            }
        
            int lastNumber = fCard.cardNumber;
            CGRect lastFrame = fCard.frame;
    
            while (lastNumber >= 3) {
                lastNumber -= 3;
                PalCard *tmp = self.palCards[lastNumber];
                if (!tmp.isDisappear) {
                    CGRect tmpFrame = tmp.frame;
                    [tmp moveTo:lastFrame withDuration:_ANITIME_SHORT];
                    lastFrame = tmpFrame;
                    tmp.cardNumber = lastNumber;
                }
            }
            [fCard disappearWithDuration:_ANITIME_SHORT];
    
            lastNumber = sCard.cardNumber;
            lastFrame = sCard.frame;
            while (lastNumber >= 3) {
                lastNumber -= 3;
                PalCard *tmp = self.palCards[lastNumber];
                if (!tmp.isDisappear) {
                    CGRect tmpFrame = tmp.frame;
                    [tmp moveTo:lastFrame withDuration:_ANITIME_SHORT];
                    lastFrame = tmpFrame;
                    tmp.cardNumber = lastNumber;
                }

            }
            [sCard disappearWithDuration:_ANITIME_SHORT];
    }
}


- (void) wrongCardAnimation: (NSTimer *) timer
{
    [self.LastCard flipWithDuration:_ANITIME_SHORT];
    [self.CurrentCard flipWithDuration:_ANITIME_SHORT];
    [NSTimer scheduledTimerWithTimeInterval: _ANITIME_SHORT target:self selector:@selector(blackAnimationOver) userInfo:nil repeats: NO];
}

- (void) blackAnimationOver
{
    _wrongAnimating = NO;
}



#pragma mark  alert  delegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        
        if([self.mode isEqualToString:@"hard"]) {
            [self cardsDisappear];
            [self cardsMoveToOrigin];
        }
        else {
            [self cardsInvisiableWithDuration:_ANITIME_LONG];
        }
        
        self.hintView.image = [UIImage imageNamed:_HintPrepareIMG];
        self.hintView.alpha = 0.0;
        
        [UIView animateWithDuration:0.3
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.hintView.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                         }];
        
        [NSTimer scheduledTimerWithTimeInterval: _ANITIME_LONG target:self selector:@selector(nextRound:) userInfo:nil repeats: NO];
    }
    else {
        _gameOver = YES;
        
        if (!_soundOff) {
            
            [MCSoundBoard addAudioAtPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"main0%d.mp3", arc4random() % 2 + 1] ofType:nil] forKey:@"MainBGM"];
            
            [MCSoundBoard loopAudioForKey:@"MainBGM" numberOfLoops:-1];
            [MCSoundBoard playAudioForKey:@"MainBGM" fadeInInterval:1.0];
        }
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)Card1Pressed:(UITapGestureRecognizer *)sender {

    [self processWithCardNumber:1];
}

- (IBAction)Card2Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:2];
}

- (IBAction)Card3Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:3];
}

- (IBAction)Card4Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:4];
}

- (IBAction)Card5Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:5];
}

- (IBAction)Card6Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:6];
}

- (IBAction)Card7Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:7];
}

- (IBAction)Card8Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:8];
}

- (IBAction)Card9Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:9];
}

- (IBAction)Card10Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:10];
}


- (IBAction)Card11Pressed:(UITapGestureRecognizer *)sender {

    [self processWithCardNumber:11];
}

- (IBAction)Card12Pressed:(UITapGestureRecognizer *)sender {
    
    [self processWithCardNumber:12];
}


- (void)viewDidUnload
{
    [self setCard1:nil];
    [self setCard2:nil];
    [self setCard3:nil];
    [self setCard4:nil];
    [self setCard5:nil];
    [self setCard6:nil];
    [self setCard7:nil];
    [self setCard8:nil];
    [self setCard9:nil];
    [self setCard10:nil];
    [self setCard11:nil];
    [self setCard12:nil];

    [self setLastCard:nil];
    [self setCurrentCard:nil];
    
    [self setDisplay:nil];
    [self setTextDisplay:nil];

    [self setHintView:nil];
    [super viewDidUnload];
}

@end

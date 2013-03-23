//
//  MCSoundBoard.m
//  MCSoundBoard
//
//  Created by Baglan Dosmagambetov on 7/14/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
//

#import "MCSoundBoard.h"
#import <AudioToolbox/AudioToolbox.h>

#define MCSOUNDBOARD_AUDIO_FADE_STEPS   30

@implementation MCSoundBoard {
    NSMutableDictionary *_sounds;
    NSMutableDictionary *_audio;
}

// Sound board singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
+ (MCSoundBoard *)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _sounds = [NSMutableDictionary dictionary];
        _audio = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
    
    [_sounds setObject:[NSNumber numberWithInt:soundId] forKey:key];
}

+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addSoundAtPath:filePath forKey:key];
}

- (void)playSoundForKey:(id)key
{
    SystemSoundID soundId = [(NSNumber *)[_sounds objectForKey:key] intValue];
    AudioServicesPlaySystemSound(soundId);
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_SOUND_PLAYED_NOTIFICATION object:key];
}

+ (void)playSoundForKey:(id)key
{
    [[self sharedInstance] playSoundForKey:key];
}

- (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [_audio setObject:player forKey:key];
}

+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    [[self sharedInstance] addAudioAtPath:filePath forKey:key];
}

- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > 1.0 ? 1.0 : volume;
    player.volume = volume;
    
    if (volume == 1.0) {
        [timer invalidate];
    }
}

- (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeInInterval > 0.0) {
        player.volume = 0.0;
        NSTimeInterval interval = fadeInInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:player
                                        repeats:YES];
    }
    
    [player play];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_AUDIO_STARTED_NOTIFICATION object:key];
}

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:fadeInInterval];
}

+ (void)playAudioForKey:(id)key
{
    [[self sharedInstance] playAudioForKey:key fadeInInterval:0.0];
}


- (void)fadeOutAndStop:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player stop];
    }
}

- (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndStop:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player stop];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_AUDIO_STOPPED_NOTIFICATION object:key];
}

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:fadeOutInterval];
}

+ (void)stopAudioForKey:(id)key
{
    [[self sharedInstance] stopAudioForKey:key fadeOutInterval:0.0];
}


- (void)fadeOutAndPause:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0) {
        [timer invalidate];
        [player pause];
    }
}

- (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [_audio objectForKey:key];
    
    // If fade in inteval interval is not 0, schedule fade in
    if (fadeOutInterval > 0) {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndPause:)
                                       userInfo:player
                                        repeats:YES];
    } else {
        [player pause];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MCSOUNDBOARD_AUDIO_PAUSED_NOTIFICATION object:key];
}


+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:fadeOutInterval];
}

+ (void)pauseAudioForKey:(id)key
{
    [[self sharedInstance] pauseAudioForKey:key fadeOutInterval:0.0];
}


- (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [_audio objectForKey:key];
}

+ (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [[self sharedInstance] audioPlayerForKey:key];
}

+ (void)loopAudioForKey:(id)key numberOfLoops:(NSInteger)loops
{
    AVAudioPlayer * player = [self audioPlayerForKey:key];
    player.numberOfLoops = loops;
}

@end

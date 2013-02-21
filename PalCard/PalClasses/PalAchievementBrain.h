//
//  PalAchievementBrain.h
//  PalCard
//
//  Created by FlyinGeek on 13-2-4.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalAchievementBrain : NSObject


// return YES if new achievement unlocked
+ (BOOL) newAchievementUnlocked: (NSString *)gameMode
                            win: (BOOL)win
                       timeUsed: (float)usedTime
                       timeLeft: (float)lastTime
                    wrongsTimes: (int)wrongs
                     rightTimes: (int)rights
              endWithBlackOrNot: (BOOL) endWithBlack;



@end

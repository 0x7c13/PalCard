//
//  PalAchievementBrain.h
//  PalCard
//
//  Created by FlyinGeek on 13-2-4.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalAchievementBrain : NSObject



+ (BOOL) newAchievementUnlocked: (NSString *)gameMode
                      winOrLose: (BOOL)win
                     timeRemain: (int)usedTime
                    wrongsTimes: (int)wrongs
                     rightTimes: (int)rights
              endWithBlackOrNot: (BOOL) endWithBlack;



@end

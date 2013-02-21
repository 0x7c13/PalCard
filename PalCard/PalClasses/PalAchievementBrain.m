//
//  PalAchievementBrain.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-4.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalAchievementBrain.h"


@implementation PalAchievementBrain



+ (BOOL) newAchievementUnlocked: (NSString *)gameMode
                            win: (BOOL)win
                       timeUsed: (float)usedTime
                       timeLeft: (float)lastTime
                    wrongsTimes: (int)wrongs
                     rightTimes: (int)rights
              endWithBlackOrNot: (BOOL) endWithBlack

{
    bool flag = NO;
    
    
    // Get game data from UserDefault
    
    NSNumber *totalGames = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalGames"];
    NSNumber *totalWins = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalWins"];
    NSNumber *totalLosses = [[NSUserDefaults standardUserDefaults] valueForKey:@"totalLosses"];
    NSNumber *wins = [[NSUserDefaults standardUserDefaults] valueForKey:@"wins"];
    NSNumber *losses = [[NSUserDefaults standardUserDefaults] valueForKey:@"losses"];

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
    
    
    // calculate new game data 
    totalGames = [NSNumber numberWithInteger:[totalGames integerValue] + 1];
    
    if (win) {
        
        totalWins = [NSNumber numberWithInteger:[totalWins integerValue] + 1];
        wins = [NSNumber numberWithInteger:[wins integerValue] + 1];
        losses = [NSNumber numberWithInteger:0];
        
        if ([gameMode isEqualToString:@"easy"]) {
            totalEasyWins = [NSNumber numberWithInteger:[totalEasyWins integerValue] + 1];
            easyWins = [NSNumber numberWithInteger:[easyWins integerValue] + 1];
            easyLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"normal"]) {
            totalNormalWins = [NSNumber numberWithInteger:[totalNormalWins integerValue] + 1];
            normalWins = [NSNumber numberWithInteger:[normalWins integerValue] + 1];
            normalLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"hard"]) {
            totalHardWins = [NSNumber numberWithInteger:[totalHardWins integerValue] + 1];
            hardWins = [NSNumber numberWithInteger:[hardWins integerValue] + 1];
            hardLosses = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"freeStyle"]) {
            totalFreeWins = [NSNumber numberWithInteger:[totalFreeWins integerValue] + 1];
            freeWins = [NSNumber numberWithInteger:[freeWins integerValue] + 1];
            freeLosses = [NSNumber numberWithInteger:0];
        }
    }
    
    if (!win) {
        
        totalLosses = [NSNumber numberWithInteger:[totalLosses integerValue] + 1];
        losses = [NSNumber numberWithInteger:[losses integerValue] + 1];
        wins = [NSNumber numberWithInteger:0];
        
        if ([gameMode isEqualToString:@"easy"]) {
            totalEasyLosses = [NSNumber numberWithInteger:[totalEasyLosses integerValue] + 1];
            easyLosses = [NSNumber numberWithInteger:[easyLosses integerValue] + 1];
            easyWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"normal"]) {
            totalNormalLosses = [NSNumber numberWithInteger:[totalNormalLosses integerValue] + 1];
            normalLosses = [NSNumber numberWithInteger:[normalLosses integerValue] + 1];
            normalWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"hard"]) {
            totalHardLosses = [NSNumber numberWithInteger:[totalHardLosses integerValue] + 1];
            hardLosses = [NSNumber numberWithInteger:[hardLosses integerValue] + 1];
            hardWins = [NSNumber numberWithInteger:0];
        }
        if ([gameMode isEqualToString:@"freeStyle"]) {
            totalFreeLosses = [NSNumber numberWithInteger:[totalFreeLosses integerValue] + 1];
            freeLosses = [NSNumber numberWithInteger:[freeLosses integerValue] + 1];
            freeWins = [NSNumber numberWithInteger:0];
        }
    }
    
    // read card unlock information for userdefault

    NSMutableArray *CardIsUnlocked = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"CardIsUnlocked"]];

 
    // achievement brain
    if ([CardIsUnlocked[1] isEqualToString:@"NO"]) {
        if ([totalWins isEqualToNumber:[NSNumber numberWithInteger: 1]]) {
            CardIsUnlocked[1] = @"YES";
            flag = YES;
        }
    }

    
    if ([CardIsUnlocked[2] isEqualToString:@"NO"]) {
        if ([totalLosses isEqualToNumber:[NSNumber numberWithInteger: 1]]) {
            CardIsUnlocked[2] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[3] isEqualToString:@"NO"]) {
        if ([totalEasyWins isEqualToNumber:[NSNumber numberWithInteger: 1]]) {
            CardIsUnlocked[3] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[4] isEqualToString:@"NO"]) {
        if ([totalNormalWins isEqualToNumber:[NSNumber numberWithInteger: 1]]) {
            CardIsUnlocked[4] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[5] isEqualToString:@"NO"]) {
        if ([totalHardWins isEqualToNumber:[NSNumber numberWithInteger: 1]]) {
            CardIsUnlocked[5] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[6] isEqualToString:@"NO"]) {
        if ([totalWins isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[6] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[7] isEqualToString:@"NO"]) {
        if ([totalLosses isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[7] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[8] isEqualToString:@"NO"]) {
        if ([totalEasyWins isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[8] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[9] isEqualToString:@"NO"]) {
        if ([totalEasyLosses isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[9] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[10] isEqualToString:@"NO"]) {
        if ([totalNormalWins isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[10] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[11] isEqualToString:@"NO"]) {
        if ([totalNormalLosses isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[11] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[12] isEqualToString:@"NO"]) {
        if ([totalHardWins isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[12] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[13] isEqualToString:@"NO"]) {
        if ([totalHardLosses isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[13] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[14] isEqualToString:@"NO"]) {
        if ([totalWins isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[14] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[15] isEqualToString:@"NO"]) {
        if ([totalLosses isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[15] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[16] isEqualToString:@"NO"]) {
        if ([totalEasyWins isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[16] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[17] isEqualToString:@"NO"]) {
        if ([totalNormalWins isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[17] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[18] isEqualToString:@"NO"]) {
        if ([totalHardWins isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[18] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[19] isEqualToString:@"NO"]) {
        if ([totalEasyLosses isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[19] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[20] isEqualToString:@"NO"]) {
        if ([totalNormalLosses isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[20] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[21] isEqualToString:@"NO"]) {
        if ([totalHardLosses isEqualToNumber:[NSNumber numberWithInteger: 30]]) {
            CardIsUnlocked[21] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[22] isEqualToString:@"NO"]) {
        if ([wins isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[22] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[23] isEqualToString:@"NO"]) {
        if ([losses isEqualToNumber:[NSNumber numberWithInteger: 10]]) {
            CardIsUnlocked[23] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[24] isEqualToString:@"NO"]) {
        if ([totalGames isEqualToNumber:[NSNumber numberWithInteger: 50]]) {
            CardIsUnlocked[24] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[25] isEqualToString:@"NO"]) {
        if ([totalWins isEqualToNumber:[NSNumber numberWithInteger: 50]]) {
            CardIsUnlocked[25] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[26] isEqualToString:@"NO"]) {
        if ([totalLosses isEqualToNumber:[NSNumber numberWithInteger: 50]]) {
            CardIsUnlocked[26] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[27] isEqualToString:@"NO"]) {
        if ([easyWins isEqualToNumber:[NSNumber numberWithInteger: 20]]) {
            CardIsUnlocked[27] = @"YES";
            flag = YES;
        }
    }
    
    
    if ([CardIsUnlocked[28] isEqualToString:@"NO"]) {
        if ([normalWins isEqualToNumber:[NSNumber numberWithInteger: 20]]) {
            CardIsUnlocked[28] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[29] isEqualToString:@"NO"]) {
        if ([hardWins isEqualToNumber:[NSNumber numberWithInteger: 20]]) {
            CardIsUnlocked[29] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[30] isEqualToString:@"NO"]) {
        if ([totalWins isEqualToNumber:[NSNumber numberWithInteger: 100]]) {
            CardIsUnlocked[30] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[31] isEqualToString:@"NO"]) {
        if ([freeWins isEqualToNumber:[NSNumber numberWithInteger: 15]]) {
            CardIsUnlocked[31] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[32] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"easy"] && usedTime <= 5 && win) {
            CardIsUnlocked[32] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[33] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"normal"] && usedTime <= 5 && win) {
            CardIsUnlocked[33] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[34] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"hard"] && usedTime <= 5 && win) {
            CardIsUnlocked[34] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[35] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"easy"] && wrongs == 0 && win) {
            CardIsUnlocked[35] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[36] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"normal"] && wrongs == 0 && win) {
            CardIsUnlocked[36] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[37] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"hard"] && wrongs == 0 && win) {
            CardIsUnlocked[37] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[38] isEqualToString:@"NO"]) {
        if ([totalLosses isEqualToNumber:[NSNumber numberWithInteger: 100]]) {
            CardIsUnlocked[38] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[39] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"easy"] && rights == 0) {
            CardIsUnlocked[39] = @"YES";
            flag = YES;
        }
    }

    
    if ([CardIsUnlocked[40] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"normal"] && rights == 0) {
            CardIsUnlocked[40] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[41] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"hard"] && rights == 0) {
            CardIsUnlocked[41] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[42] isEqualToString:@"NO"]) {
        if (endWithBlack) {
            CardIsUnlocked[42] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[43] isEqualToString:@"NO"]) {
        if (endWithBlack && rights == 0) {
            CardIsUnlocked[43] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[44] isEqualToString:@"NO"]) {
        if ([totalEasyWins isEqualToNumber:[NSNumber numberWithInteger: 100]]) {
            CardIsUnlocked[44] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[45] isEqualToString:@"NO"]) {
        if ([totalNormalWins isEqualToNumber:[NSNumber numberWithInteger: 100]]) {
            CardIsUnlocked[45] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[46] isEqualToString:@"NO"]) {
        if ([totalHardWins isEqualToNumber:[NSNumber numberWithInteger: 100]]) {
            CardIsUnlocked[46] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[47] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"freeStyle"] && wrongs == 0 && win) {
            CardIsUnlocked[47] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[48] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"normal"] && win && lastTime <= 1) {
            CardIsUnlocked[48] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[49] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"hard"] && win && lastTime <= 1) {
            CardIsUnlocked[49] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[50] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"freeStyle"] && win && lastTime <= 1) {
            CardIsUnlocked[50] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[51] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"freeStyle"] && usedTime <= 5 && win) {
            CardIsUnlocked[51] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[52] isEqualToString:@"NO"]) {
        if ([easyWins isEqualToNumber:[NSNumber numberWithInteger: 15]]) {
            CardIsUnlocked[52] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[53] isEqualToString:@"NO"]) {
        if ([normalWins isEqualToNumber:[NSNumber numberWithInteger: 15]]) {
            CardIsUnlocked[53] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[54] isEqualToString:@"NO"]) {
        if ([hardWins isEqualToNumber:[NSNumber numberWithInteger: 15]]) {
            CardIsUnlocked[54] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[55] isEqualToString:@"NO"]) {
        if (arc4random() % 1000 == 903) {
            CardIsUnlocked[55] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[56] isEqualToString:@"NO"]) {
        if (arc4random() % 1000 == 903 && !win) {
            CardIsUnlocked[56] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[57] isEqualToString:@"NO"]) {
        if (arc4random() % 1000 == 903 && win) {
            CardIsUnlocked[57] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[58] isEqualToString:@"NO"]) {
        if ([gameMode isEqualToString:@"easy"] && win && lastTime <= 1) {
            CardIsUnlocked[58] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[59] isEqualToString:@"NO"]) {
        if ([easyLosses isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[59] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[60] isEqualToString:@"NO"]) {
        if ([normalLosses isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[60] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[61] isEqualToString:@"NO"]) {
        if ([hardLosses isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[61] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[62] isEqualToString:@"NO"]) {
        if ([easyWins isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[62] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[63] isEqualToString:@"NO"]) {
        if ([normalWins isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[63] = @"YES";
            flag = YES;
        }
    }
    
    if ([CardIsUnlocked[64] isEqualToString:@"NO"]) {
        if ([hardWins isEqualToNumber:[NSNumber numberWithInteger: 5]]) {
            CardIsUnlocked[64] = @"YES";
            flag = YES;
        }
    }
    
    
    // Store new game data in userdefaults
    
    [[NSUserDefaults standardUserDefaults] setValue:CardIsUnlocked forKey:@"CardIsUnlocked"];
    
    [[NSUserDefaults standardUserDefaults] setValue:totalGames forKey:@"totalGames"];
    [[NSUserDefaults standardUserDefaults] setValue:totalWins forKey:@"totalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalLosses forKey:@"totalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:wins forKey:@"wins"];
    [[NSUserDefaults standardUserDefaults] setValue:losses forKey:@"losses"];
    

    [[NSUserDefaults standardUserDefaults] setValue:totalEasyWins forKey:@"totalEasyWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalNormalWins forKey:@"totalNormalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalHardWins forKey:@"totalHardWins"];
    [[NSUserDefaults standardUserDefaults] setValue:totalFreeWins forKey:@"totalFreeWins"];

    [[NSUserDefaults standardUserDefaults] setValue:totalEasyLosses forKey:@"totalEasyLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalNormalLosses  forKey:@"totalNormalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalHardLosses forKey:@"totalHardLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:totalFreeLosses forKey:@"totalFreeLosses"];
    
    [[NSUserDefaults standardUserDefaults] setValue:easyWins forKey:@"easyWins"];
    [[NSUserDefaults standardUserDefaults] setValue:normalWins forKey:@"normalWins"];
    [[NSUserDefaults standardUserDefaults] setValue:hardWins forKey:@"hardWins"];
    [[NSUserDefaults standardUserDefaults] setValue:freeWins forKey:@"freeWins"];
    
    [[NSUserDefaults standardUserDefaults] setValue:easyLosses forKey:@"easyLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:normalLosses forKey:@"normalLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:hardLosses forKey:@"hardLosses"];
    [[NSUserDefaults standardUserDefaults] setValue:freeLosses forKey:@"freeLosses"];
    
    return flag;
}



@end

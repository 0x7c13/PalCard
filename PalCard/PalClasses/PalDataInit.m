//
//  PalDataInit.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-21.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalDataInit.h"

@implementation PalDataInit

+ (void)gameDataInit
{
    
    // V 1.0 PalCard
    
    NSString *myLove = [[NSUserDefaults standardUserDefaults] valueForKey:@"myLove"];
    
    if (!myLove) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"FY" forKey:@"myLove"];
        
        NSString *sound = [NSString stringWithFormat:@"NO"];
        [[NSUserDefaults standardUserDefaults] setValue:sound forKey:@"turnOffSound"];
        
        //  lock every sigle card
        
        NSMutableArray *CardIsUnlocked = [[NSUserDefaults standardUserDefaults] valueForKey:@"CardIsUnlocked"];
        
        if (!CardIsUnlocked) {
            
            CardIsUnlocked = [NSMutableArray arrayWithCapacity:100];
            for (int i = 0; i < 100; i++) {
                CardIsUnlocked[i] = @"NO";
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:CardIsUnlocked forKey:@"CardIsUnlocked"];
        }
        
        // General Data
        NSNumber *totalGames = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalGames forKey:@"totalGames"];
        
        NSNumber *totalWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalWins forKey:@"totalWins"];
        
        NSNumber *totalLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalLosses forKey:@"totalLosses"];
        
        NSNumber *wins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:wins forKey:@"wins"];
        
        NSNumber *losses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:losses forKey:@"losses"];
        
        
        // Specific Data
        
        NSNumber *totalEasyWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalEasyWins forKey:@"totalEasyWins"];
        
        NSNumber *totalNormalWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalNormalWins forKey:@"totalNormalWins"];
        
        NSNumber *totalHardWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalHardWins forKey:@"totalHardWins"];
        
        
        NSNumber *totalEasyLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalEasyLosses forKey:@"totalEasyLosses"];
        
        NSNumber *totalNormalLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalNormalLosses  forKey:@"totalNormalLosses"];
        
        NSNumber *totalHardLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalHardLosses forKey:@"totalHardLosses"];
        
        
        NSNumber *easyWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:easyWins forKey:@"easyWins"];
        
        NSNumber *normalWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:normalWins forKey:@"normalWins"];
        
        NSNumber *hardWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:hardWins forKey:@"hardWins"];
        
        
        NSNumber *easyLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:easyLosses forKey:@"easyLosses"];
        
        NSNumber *normalLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:normalLosses forKey:@"normalLosses"];
        
        NSNumber *hardLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:hardLosses forKey:@"hardLosses"];
    }
    
    
    // V 1.1 PalCard additional
    NSString *myLove2 = [[NSUserDefaults standardUserDefaults] valueForKey:@"myLove2"];
    
    if (!myLove2) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"FY" forKey:@"myLove2"];
        
        NSNumber *totalFreeWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalFreeWins forKey:@"totalFreeWins"];
        
        
        NSNumber *totalFreeLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:totalFreeLosses forKey:@"totalFreeLosses"];
        
        
        NSNumber *freeWins = @0;
        [[NSUserDefaults standardUserDefaults] setValue:freeWins forKey:@"freeWins"];
        
        
        NSNumber *freeLosses = @0;
        [[NSUserDefaults standardUserDefaults] setValue:freeLosses forKey:@"freeLosses"];
    }
    
}



@end


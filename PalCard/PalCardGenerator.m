//
//  PalCardGenerator.m
//  PalCard
//
//  Created by FlyinGeek on 13-1-31.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalCardGenerator.h"

@interface PalCardGenerator () {
    bool _initialized;
    bool _lastIsBlack;
    NSInteger cards[7];
    NSInteger used[7];
}

@end


@implementation PalCardGenerator


- (void)prepare
{
    int cardNumber;
    
    bool _same = NO;
    int i = 1;
    
    cardNumber = arc4random() % 64 + 301;
    cards[1] = cardNumber;
    
    while (i <= 6) {
        
        _same = NO;
        
        cardNumber = arc4random() % 64 + 301;
        
        for (int j = 1; j <= i ; j++)
        {
            if (cardNumber == cards[j])
            {
                _same = YES;
                break;
            }
        }
        if (!_same)  {
            cards[++i] = cardNumber;
        }
    }
    
  //  for (int i = 1; i <= 6; i++)
  //      NSLog(@"%d\n", cards[i]);

}

- (NSString *) lastIsBlackOrNot
{
    if(_lastIsBlack) {
        return @"YES";
    }
    else return @"NO";
}

- (NSString *)getACardWithPath
{
    if (!_initialized) {
        [self prepare];
        _initialized = YES;
    }
    
    int cardNumber = arc4random() % 6 + 1;
    
    while (used[cardNumber] == 2) {
        cardNumber = (random() + arc4random()) % 6 + 1;
    }
    
    used[cardNumber] ++;
    
    NSString *path;
    
    if(self.NumbersOfBlackCards == 2) {
        if (cardNumber == 1 || cardNumber == 2) {
            path = [NSString stringWithFormat:@"palsource_black/%d.png", cards[cardNumber]];
            _lastIsBlack = YES;
            return path;
        }
    }
    
    if(self.NumbersOfBlackCards == 1) {
        if (cardNumber == 1) {
            path = [NSString stringWithFormat:@"palsource_black/%d.png", cards[cardNumber]];
            _lastIsBlack = YES;
            return path;
        }
    }

    path = [NSString stringWithFormat:@"palsource/%d.png", cards[cardNumber]];
    _lastIsBlack = NO;
    return path;
}




@end



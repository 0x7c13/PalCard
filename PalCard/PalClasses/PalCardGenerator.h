//
//  PalCardGenerator.h
//  PalCard
//
//  Created by FlyinGeek on 13-1-31.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PalCardGenerator : NSObject 

@property (nonatomic) NSInteger NumbersOfBlackCards;


- (NSString *) getACardWithPath;
- (NSString *) lastIsBlack;


@end

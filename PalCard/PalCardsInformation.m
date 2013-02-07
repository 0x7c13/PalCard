//
//  PalCardsInformation.m
//  PalCard
//
//  Created by FlyinGeek on 13-2-4.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import "PalCardsInformation.h"

@implementation PalCardsInformation


// from 1 to 64

+ (NSString *) nameOfCardAtIndex:(NSInteger)index
{
    NSString *cardName;
    
    switch (index) {
        case 1:
            cardName = @"李逍遥";
            break;
        case 2:
            cardName = @"赵灵儿";
            break;
        case 3:
            cardName = @"赵灵儿 梦蛇";
            break;
        case 4:
            cardName = @"林月如";
            break;
        case 5:
            cardName = @"阿奴";
            break;
        case 6:
            cardName = @"酒剑仙";
            break;
        case 7:
            cardName = @"拜月教主";
            break;
        case 8:
            cardName = @"王小虎";
            break;
        case 9:
            cardName = @"苏媚";
            break;
        case 10:
            cardName = @"沈欺霜";
            break;
        case 11:
            cardName = @"李忆如";
            break;
        case 12:
            cardName = @"孔磷";
            break;
        case 13:
            cardName = @"魔尊";
            break;
        case 14:
            cardName = @"景天";
            break;
        case 15:
            cardName = @"唐雪见";
            break;
        case 16:
            cardName = @"龙葵";
            break;
        case 17:
            cardName = @"龙葵鬼";
            break;
        case 18:
            cardName = @"紫萱";
            break;
        case 19:
            cardName = @"重楼";
            break;
        case 20:
            cardName = @"徐长卿";
            break;
        case 21:
            cardName = @"南宫煌";
            break;
        case 22:
            cardName = @"温慧";
            break;
        case 23:
            cardName = @"星璇";
            break;
        case 24:
            cardName = @"王蓬絮";
            break;
        case 25:
            cardName = @"雷元戈";
            break;
        case 26:
            cardName = @"云天河";
            break;
        case 27:
            cardName = @"韩菱纱";
            break;
        case 28:
            cardName = @"柳梦璃";
            break;
        case 29:
            cardName = @"慕容紫英";
            break;
        case 30:
            cardName = @"玄霄";
            break;
        case 31:
            cardName = @"姜云凡";
            break;
        case 32:
            cardName = @"唐雨柔";
            break;
        case 33:
            cardName = @"龙幽";
            break;
        case 34:
            cardName = @"小蛮";
            break;
        case 35:
            cardName = @"千杯不醉";
            break;
        case 36:
            cardName = @"五毒兽";
            break;
        case 37:
            cardName = @"蛇妖男";
            break;
        case 38:
            cardName = @"水魔兽";
            break;
        case 39:
            cardName = @"画妖";
            break;
        case 40:
            cardName = @"帝江神兽";
            break;
        case 41:
            cardName = @"赝月";
            break;
        case 42:
            cardName = @"肥肥";
            break;
        case 43:
            cardName = @"狐妖女";
            break;
        case 44:
            cardName = @"熔岩兽王";
            break;
        case 45:
            cardName = @"火麒麟";
            break;
        case 46:
            cardName = @"镇狱明王";
            break;
        case 47:
            cardName = @"积粮隐者";
            break;
        case 48:
            cardName = @"赤鬼王";
            break;
        case 49:
            cardName = @"毒娘子";
            break;
        case 50:
            cardName = @"邪剑仙";
            break;
        case 51:
            cardName = @"纸马";
            break;
        case 52:
            cardName = @"叶灵";
            break;
        case 53:
            cardName = @"暗香";
            break;
        case 54:
            cardName = @"句芒";
            break;
        case 55:
            cardName = @"碟精";
            break;
        case 56:
            cardName = @"羽民";
            break;
        case 57:
            cardName = @"金翅凤凰";
            break;
        case 58:
            cardName = @"璇龟";
            break;
        case 59:
            cardName = @"刑天";
            break;
        case 60:
            cardName = @"金蝉鬼母";
            break;
        case 61:
            cardName = @"天妖皇";
            break;
        case 62:
            cardName = @"菜刀婆婆";
            break;
        case 63:
            cardName = @"财神爷";
            break;
        case 64:
            cardName = @"罗刹鬼婆";
            break;
        default:
            break;
    }
    
    return cardName;
}


// from 1 to 64
+ (NSString *) descriptionOfCardAtIndex:(NSInteger)index
{
    NSString *description;
    
    switch (index) {
        case 1:
            description = @"游戏初次胜利时可获得";
            break;
        case 2:
            description = @"游戏初次失败时可获得";
            break;
        case 3:
            description = @"简单模式初次胜利时可获得";
            break;
        case 4:
            description = @"普通模式初次胜利时可获得";
            break;
        case 5:
            description = @"困难模式初次胜利时可获得";
            break;
        case 6:
            description = @"总游戏胜利次数达到10次时可获得";
            break;
        case 7:
            description = @"总游戏失败次数达到10次时可获得";
            break;
        case 8:
            description = @"简单模式胜利次数达到10次时可获得";
            break;
        case 9:
            description = @"简单模式失败次数达到10次时可获得";
            break;
        case 10:
            description = @"普通模式胜利次数达到10次时可获得";
            break;
        case 11:
            description = @"普通模式失败次数达到10次时可获得";
            break;
        case 12:
            description = @"困难模式胜利次数达到10次时可获得";
            break;
        case 13:
            description = @"困难模式失败次数达到10次时可获得";
            break;
        case 14:
            description = @"总游戏胜利次数达到30次时可获得";
            break;
        case 15:
            description = @"总游戏失败次数达到30次时可获得";
            break;
        case 16:
            description = @"简单模式胜利次数达到30次时可获得";
            break;
        case 17:
            description = @"普通模式胜利次数达到30次时可获得";
            break;
        case 18:
            description = @"困难模式胜利次数达到30次时可获得";
            break;
        case 19:
            description = @"简单模式失败次数达到30次时可获得";
            break;
        case 20:
            description = @"普通模式失败次数达到30次时可获得";
            break;
        case 21:
            description = @"困难模式失败次数达到30次时可获得";
            break;
        case 22:
            description = @"连续胜利次数达到10次时可获得";
            break;
        case 23:
            description = @"连续失败次数达到10次时可获得";
            break;
        case 24:
            description = @"总游戏次数达到50次时可获得";
            break;
        case 25:
            description = @"总游戏胜利次数达到50次时可获得";
            break;
        case 26:
            description = @"总游戏失败次数达到50次时可获得";
            break;
        case 27:
            description = @"简单模式连续胜利20场时可获得";
            break;
        case 28:
            description = @"普通模式连续胜利20场时可获得";
            break;
        case 29:
            description = @"困难模式连续胜利20场时可获得";
            break;
        case 30:
            description = @"游戏总胜利次数达到100场时可获得";
            break;
        case 31:
            description = @"总游戏次数达到200场时可获得";
            break;
        case 32:
            description = @"简单模式5秒内完成时可获得";
            break;
        case 33:
            description = @"普通模式5秒内完成时可获得";
            break;
        case 34:
            description = @"困难模式5秒内完成时可获得";
            break;
        case 35:
            description = @"简单模式不出一次错完成游戏时可获得";
            break;
        case 36:
            description = @"普通模式不出一次错完成游戏时可获得";
            break;
        case 37:
            description = @"困难模式不出一次错完成游戏时可获得";
            break;
        case 38:
            description = @"游戏总失败次数达到100场时可获得";
            break;
        case 39:
            description = @"简单模式未翻开至少一对牌时可获得";
            break;
        case 40:
            description = @"普通模式未翻开至少一对牌时可获得";
            break;
        case 41:
            description = @"困难模式未翻开至少一对牌时可获得";
            break;
        case 42:
            description = @"翻开黑牌失败时可获得";
            break;
        case 43:
            description = @"翻开第一张即是黑牌时课获得";
            break;
        case 44:
            description = @"简单模式游戏胜利次数达100次时可获得";
            break;
        case 45:
            description = @"普通模式游戏胜利次数达100次时可获得";
            break;
        case 46:
            description = @"困难模式游戏胜利次数达100次时可获得";
            break;
        case 47:
            description = @"总游戏次数达300次时可获得";
            break;
        case 48:
            description = @"普通模式最后一秒完成时可获得";
            break;
        case 49:
            description = @"困难模式最后一秒完成时可获得";
            break;
        case 50:
            description = @"总游戏胜利次数达到250次时可获得";
            break;
        case 51:
            description = @"总游戏失败次数达到250次时可获得";
            break;
        case 52:
            description = @"简单模式连续胜利15场时可获得";
            break;
        case 53:
            description = @"普通模式连续胜利15场时可获得";
            break;
        case 54:
            description = @"困难模式连续胜利15场时可获得";
            break;
        case 55:
            description = @"游戏结束后有一定几率获得";
            break;
        case 56:
            description = @"游戏失败后有一定几率获得";
            break;
        case 57:
            description = @"游戏胜利后有一定几率获得";
            break;
        case 58:
            description = @"简单模式最后一秒完成时可获得";
            break;
        case 59:
            description = @"简单模式连续失败5场时可获得";
            break;
        case 60:
            description = @"普通模式连续失败5场时可获得";
            break;
        case 61:
            description = @"困难模式连续失败5场时可获得";
            break;
        case 62:
            description = @"简单模式连续胜利5场时可获得";
            break;
        case 63:
            description = @"普通模式连续胜利5场时可获得";
            break;
        case 64:
            description = @"困难模式连续胜利5场时可获得";
            break;
        default:
            break;
    }

    return description;
}

@end

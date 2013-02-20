//
//  PalViewController.h
//  PalCard
//
//  Created by FlyinGeek on 13-1-28.
//  Copyright (c) 2013年 FlyinGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface PalViewController : UIViewController <UIAlertViewDelegate, MBProgressHUDDelegate>

@property (copy, nonatomic) NSString *mode;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end



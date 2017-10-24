//
//  TodayActiveViewController.h
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  作为RemindWidget的操作界面

#import "TodaySuperViewController.h"

@protocol TodayActiveViewControllerDelegate <NSObject>

- (void)inputString:(NSString *)str;

@end

@interface TodayActiveViewController : TodaySuperViewController

@property (weak, nonatomic) id<TodayActiveViewControllerDelegate> TAdelegate;

@property (copy, nonatomic) NSString *preInputString;

@end

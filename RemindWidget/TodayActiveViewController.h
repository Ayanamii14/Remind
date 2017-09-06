//
//  TodayActiveViewController.h
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  作为RemindWidget的操作界面

#import <UIKit/UIKit.h>

@protocol TodayActiveViewControllerDelegate <NSObject>

- (void)inputString:(NSString *)str;

@end

@interface TodayActiveViewController : UIViewController

@property (weak, nonatomic) id<TodayActiveViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *preInputString;

@end

//
//  BeginViewController.h
//  Remind
//
//  Created by lyhao on 2017/9/4.
//  Copyright © 2017年 lyhao. All rights reserved.
//  开启动画界面

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClockDateComponents) {
    ClockDateComponentsMinute,
    ClockDateComponentsHour
};

typedef void(^animationFinish)(void);
typedef void(^strokeEndAnimation)(void);

@interface BeginViewController : UIViewController

@property (copy, nonatomic) animationFinish finish;

@end

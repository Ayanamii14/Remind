//
//  TodayToolView.h
//  RemindWidget
//
//  Created by lyhao on 2017/10/24.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodayToolViewDelegate <NSObject>

- (void)TodayToolView:(UIView *)todayToolView recvKeyBoardAction:(UIButton *)sender;
- (void)TodayToolView:(UIView *)todayToolView outputSeparator:(UIButton *)sender;
- (void)TodayToolView:(UIView *)todayToolView outputEveryDay:(UIButton *)sender;
- (void)TodayToolView:(UIView *)todayToolView outputTemp:(UIButton *)sender;
- (void)TodayToolView:(UIView *)todayToolView outputAt:(UIButton *)sender;

@end

@interface TodayToolView : UIView
@property (weak, nonatomic) id <TodayToolViewDelegate> delegate;
@end

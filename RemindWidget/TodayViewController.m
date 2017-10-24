//
//  TodayViewController.m
//  RemindWidget
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayActiveViewController.h"

@interface TodayViewController () <NCWidgetProviding, UITextFieldDelegate, TodayActiveViewControllerDelegate>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
}

#pragma mark - TodaySuperViewControllerDelegate
- (void)todayAddAction {
    self.inputTextField.placeholder = @"不写点东西咋提醒呢？";
}

- (void)todayTextFieldDidBeginEditing:(UITextField *)textField {
    TodayActiveViewController *todayActiveVC = [[TodayActiveViewController alloc] init];
    todayActiveVC.TAdelegate = self;
    todayActiveVC.preInputString = self.inputTextField.text;
    todayActiveVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:todayActiveVC animated:NO completion:nil];
}


#pragma mark - TodayTrueViewControllerDelegate
- (void)inputString:(NSString *)str {
    self.inputTextField.text = str;
}

@end

//
//  TodayViewController.m
//  RemindWidget
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  

#import "TodayViewController.h"
#import "TodayActiveViewController.h"

@interface TodayViewController () <UITextFieldDelegate, TodayActiveViewControllerDelegate>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

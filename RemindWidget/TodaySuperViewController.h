//
//  TodaySuperViewController.h
//  RemindWidget
//
//  Created by lyhao on 2017/10/23.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodaySuperViewController : UIViewController

@property (strong, nonatomic) UITextField *inputTextField;
- (void)todayAddAction;
- (void)todayTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)todayTextFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)todayTextFieldShouldReturn:(UITextField *)textField;

@end

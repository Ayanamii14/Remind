//
//  TodayViewController.m
//  RemindWidget
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <Masonry.h>
#import "TodayActiveViewController.h"

@interface TodayViewController () <NCWidgetProviding,UITextFieldDelegate,TodayActiveViewControllerDelegate>

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UIToolbar *kbToolbar;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    [self defaultValueViewStyle];
}

#pragma mark - private method
- (void)defaultValueViewStyle {
    
    [self.view addSubview:self.addButton];
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [self.view addSubview:self.inputTextField];
    [self.inputTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.addButton.mas_left).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self.view addSubview:self.lineView];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    [self.view addSubview:self.describeLabel];
    [self.describeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@60);
    }];
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

#pragma mark - 按钮点击事件
- (void)addButtonAction:(UIButton *)sender {
    self.inputTextField.placeholder = @"不写点东西咋提醒呢？";
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.inputTextField.inputAccessoryView = self.kbToolbar;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    TodayActiveViewController *todayActiveVC = [[TodayActiveViewController alloc] init];
    todayActiveVC.preInputString = self.inputTextField.text;
    todayActiveVC.delegate = self;
    todayActiveVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:todayActiveVC animated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - TodayTrueViewControllerDelegate
- (void)inputString:(NSString *)str {
    self.inputTextField.text = str;
}

#pragma mark - init
- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"@Me" forState:UIControlStateNormal];
        [_addButton setTitle:@"" forState:UIControlStateHighlighted];
        [_addButton setTitleColor:[UIColor colorWithRed:219/255.0 green:78/255.0 blue:2/255.0 alpha:1] forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.borderStyle = UITextBorderStyleNone;
        [_inputTextField setFont:[UIFont systemFontOfSize:17.0f]];
    }
    return _inputTextField;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UILabel *)describeLabel {
    if(_describeLabel == nil) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.text = @"- 指定时间[8月20号12点0分]:吃饭咯//8.20@12.0\n- 每日时间[12点0分]:吃饭咯//e@12.0\n- 临时时间[12点0分]:吃饭咯//t@12.0";
        _describeLabel.textColor = [UIColor grayColor];
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _describeLabel;
}

- (UIToolbar *) kbToolbar {
    if (_kbToolbar == nil) {
        _kbToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyboard)];
        _kbToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneItem];
    }
    return _kbToolbar;
}

- (void)closeKeyboard {
    [self.inputTextField resignFirstResponder];
}

@end

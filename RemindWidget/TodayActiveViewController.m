//
//  TodayActiveViewController.m
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  

#import "TodayActiveViewController.h"
#import <Masonry.h>
#import <UserNotifications/UserNotifications.h>

@interface TodayActiveViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *describeLabel;
@property (copy, nonatomic) NSString *widgetInputString;
@property (assign, nonatomic) NSInteger badge;
@property (assign, nonatomic) BOOL isSuccess;
@property (strong, nonatomic) UIToolbar *kbToolbar;

@end

@implementation TodayActiveViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.inputTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.badge = 1;
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

- (NSDateComponents *)currentDateComponent {
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
    return dateComponent;
}

- (NSMutableArray *)analysisStrings:(NSString *)strings {
    NSMutableArray *tempArr = [NSMutableArray array];
    
    return tempArr;
}

- (void)error:(NSString *)errorMsg {
    self.inputTextField.text = @"";
    self.inputTextField.placeholder = errorMsg;
}

#pragma mark - 按钮点击事件
- (void)addButtonAction:(UIButton *)sender {
    if ([self.inputTextField.text isEqualToString:@""] || self.inputTextField.text == nil) {
        self.inputTextField.placeholder = @"不写点东西咋提醒呢？";
    }
    else {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.lyhao.Remind"];
        NSMutableArray *tempMutArr;
        if (![userDefaults objectForKey:@"note"]) {
            tempMutArr = [NSMutableArray array];
            [tempMutArr addObject:self.inputTextField.text];
        }
        else {
            tempMutArr = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"note"]];
            [tempMutArr addObject:self.inputTextField.text];
        }
        [userDefaults setObject:tempMutArr forKey:@"note"];
        [userDefaults synchronize];
        [tempMutArr removeAllObjects];
        
        //收起键盘
        [self.inputTextField resignFirstResponder];
        
        self.widgetInputString = self.inputTextField.text;
        //  吃饭咯//7.27-18.0(代表7月27号18点0分要提醒"吃饭咯")
        NSString *structureDivisionStr = @"//";//结构分隔符
        NSString *timeDivisionStr = @".";//时间分割符
        NSString *methodDivisionStr = @"@";//方式分割符
        if ([self.widgetInputString containsString:structureDivisionStr]) {
            //用"//"分割
            NSArray *structureDividedArr = [self.widgetInputString componentsSeparatedByString:structureDivisionStr];
            //标题
            NSString *title_structureDividedArr = structureDividedArr[0];
            //标识符
            NSString *tempString_structureDividedArr = structureDividedArr[1];
            
            NSArray *dateDividedArr = [tempString_structureDividedArr componentsSeparatedByString:methodDivisionStr];
            //月日
            NSString *monthDay_dateDividedArr = dateDividedArr[0];
            //时分
            NSString *hourMinArr_dateDividedArr = dateDividedArr[1];
            
            NSMutableArray *timesStateArr = [NSMutableArray array];
            
            if (!([tempString_structureDividedArr isEqualToString:@""] || tempString_structureDividedArr == nil)) {
                //t or T 临时提醒(一次)
                if ([tempString_structureDividedArr hasPrefix:@"t"] || [tempString_structureDividedArr hasPrefix:@"T"]) {
                    [timesStateArr addObject:@"t"];
                }//e or E 每日提醒
                else if ([tempString_structureDividedArr hasPrefix:@"e"] || [tempString_structureDividedArr hasPrefix:@"E"]) {
                    [timesStateArr addObject:@"e"];
                }
                else if ([tempString_structureDividedArr containsString:timeDivisionStr]){
                    //用"."分割
                    NSArray *tempArr = [monthDay_dateDividedArr componentsSeparatedByString:timeDivisionStr];
                    if (tempArr.count <=2 && tempArr.count > 0) {
                        [timesStateArr addObject:tempArr];
                    }
                    else {
                        [self error:@"格式不对哦.."];
                        return;
                    }
                }
                else {
                    [self error:@"格式不对哦.."];
                    return;
                }
                
                //时分
                NSArray *hourMinArr;
                if ([hourMinArr_dateDividedArr containsString:timeDivisionStr]) {
                    //用"."分割
                    hourMinArr = [hourMinArr_dateDividedArr componentsSeparatedByString:timeDivisionStr];
                }
                else {
                    [self error:@"格式不对哦.."];
                    return;
                }
                //发起通知
                [self notificationWithDateMethod:timesStateArr
                                            hour:[hourMinArr[0] integerValue]
                                          minute:[hourMinArr[1] integerValue]
                                           title:title_structureDividedArr];
            }
            else {
                [self error:@"格式不对哦.."];
                return;
            }
        } else {
            [self error:@"格式不对哦.."];
            return;
        }
    }
}

#pragma mark - notification
- (void)notificationWithDateMethod:(NSArray *)dateMethod hour:(NSInteger)hour minute:(NSInteger)minute title:(NSString *)title {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = title;
            content.subtitle = @"Remind";
            content.body = @"Remind";
            self.badge ++;
            content.badge = @(self.badge);
            content.sound = [UNNotificationSound defaultSound];
            
            NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"bell" withExtension:@"png"];
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attActive"
                                                                                                  URL:imageUrl
                                                                                              options:nil
                                                                                                error:nil];
            // 附件 可以是音频、图片、视频 这里是一张图片
            content.attachments = @[attachment];
            // 标识符
            content.categoryIdentifier = @"categoryIdentifier";
            
            // 2、创建通知触发
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger : 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
             */
            NSDateComponents *components = [[NSDateComponents alloc] init];
            UNCalendarNotificationTrigger *triggerC;
            components.hour = hour;
            components.minute = minute;
            
            if ([dateMethod containsObject:@"t"]) {
                components.month = [[self currentDateComponent] month];
                components.day = [[self currentDateComponent] day];
                triggerC = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                    repeats:NO];
            }
            else if ([dateMethod containsObject:@"e"]) {
                triggerC = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                    repeats:YES];
            }
            else if ([dateMethod containsObject:@"."]) {
                components.month = [dateMethod[0][0] integerValue];
                components.day = [dateMethod[0][1] integerValue];
                triggerC = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components
                                                                                    repeats:NO];
            }
            
            //通知Id的不一致，即可创建多个通知
            NSString *requestWithIdentifier = [NSString stringWithFormat:@"categoryIdentifier_%ld_%ld",[[self currentDateComponent] year],[[self currentDateComponent] month]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestWithIdentifier
                                                                                  content:content trigger:triggerC];
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request
                                                                   withCompletionHandler:^(NSError * _Nullable error) { }];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.inputTextField.text = @"";
                self.inputTextField.placeholder = @"提醒成功";
            });
        }
    }];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.inputTextField.inputAccessoryView = self.kbToolbar;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(inputString:)]) {
            [_delegate inputString:self.inputTextField.text];
        }
    }];
    return YES;
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
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - init
- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"@Me"
                    forState:UIControlStateNormal];
        [_addButton setTitle:@""
                    forState:UIControlStateHighlighted];
        [_addButton setTitleColor:[UIColor colorWithRed:219/255.0
                                                  green:78/255.0
                                                   blue:2/255.0
                                                  alpha:1]
                         forState:UIControlStateNormal];
        _addButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_addButton addTarget:self
                       action:@selector(addButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.text = self.preInputString;
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

@end

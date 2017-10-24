//
//  TodayActiveViewController.m
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//  

#import "TodayActiveViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "TodayToolView.h"

@interface TodayActiveViewController ()<TodayToolViewDelegate>

@property (copy, nonatomic) NSString *widgetInputString;
@property (assign, nonatomic) BOOL isSuccess;
@property (strong, nonatomic) TodayToolView *toolView;

@end

@implementation TodayActiveViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.inputTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.inputTextField.text = self.preInputString;
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

#pragma mark - TodaySuperViewControllerDelegate
- (void)todayAddAction {
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

- (BOOL)todayTextFieldShouldBeginEditing:(UITextField *)textField {
    //tool
    self.inputTextField.inputAccessoryView = self.toolView;
    return YES;
}

- (BOOL)todayTextFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:^{
        //把值返回上一页
        if (_TAdelegate && [_TAdelegate respondsToSelector:@selector(inputString:)]) {
            [_TAdelegate inputString:self.inputTextField.text];
        }
    }];
    return YES;
}

#pragma mark - notification
- (void)notificationWithDateMethod:(NSArray *)dateMethod hour:(NSInteger)hour minute:(NSInteger)minute title:(NSString *)title {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = title;
            content.subtitle = @"Remind";
            content.body = @"Remind";
//            self.badge ++;
//            content.badge = @(self.badge);
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
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.inputTextField.text = @"";
                self.inputTextField.placeholder = @"提醒成功";
            });
        }
    }];
}

#pragma mark - TodayToolViewDelegate
- (void)TodayToolView:(UIView *)todayToolView recvKeyBoardAction:(UIButton *)sender {
    [self.inputTextField resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:^{
        //把值返回上一页
        if (_TAdelegate && [_TAdelegate respondsToSelector:@selector(inputString:)]) {
            [_TAdelegate inputString:self.inputTextField.text];
        }
    }];
}

- (void)TodayToolView:(UIView *)todayToolView outputSeparator:(UIButton *)sender {
    NSString *s = self.inputTextField.text;
    s = [s stringByAppendingString:@"//"];
    self.inputTextField.text = s;
}

- (void)TodayToolView:(UIView *)todayToolView outputEveryDay:(UIButton *)sender {
    NSString *s = self.inputTextField.text;
    s = [s stringByAppendingString:@"e"];
    self.inputTextField.text = s;
}

- (void)TodayToolView:(UIView *)todayToolView outputTemp:(UIButton *)sender {
    NSString *s = self.inputTextField.text;
    s = [s stringByAppendingString:@"t"];
    self.inputTextField.text = s;
}

- (void)TodayToolView:(UIView *)todayToolView outputAt:(UIButton *)sender {
    NSString *s = self.inputTextField.text;
    s = [s stringByAppendingString:@"@"];
    self.inputTextField.text = s;
}

#pragma mark - init
- (TodayToolView *)toolView {
    if (!_toolView) {
        _toolView = [[TodayToolView alloc] init];
        _toolView.delegate = self;
    }
    return _toolView;
}

@end

//
//  TodaySuperViewController.m
//  RemindWidget
//
//  Created by lyhao on 2017/10/23.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "TodaySuperViewController.h"
#import "Masonry.h"
#import <NotificationCenter/NotificationCenter.h>
#import "todayModel.h"
#define SW [UIScreen mainScreen].bounds.size.width
#define TOMATOCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface TodaySuperViewController ()<UITextFieldDelegate,NCWidgetProviding, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *inputView;
@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArr;
@end

@implementation TodaySuperViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        //展开模式
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultValueViewStyle];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(SW, 110);
    }else{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"myToday.data"];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:file]];
        //变化的
        self.preferredContentSize = CGSizeMake(SW, self.tableview.rowHeight * self.dataArr.count + 110);
        [self.tableview reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

#pragma mark - private method
- (void)defaultValueViewStyle {
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@110);
    }];
    
    [self.inputView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(15);
        make.right.equalTo(self.inputView.mas_right).offset(-10);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    
    [self.inputView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView.mas_top).offset(15);
        make.left.equalTo(self.inputView.mas_left).offset(10);
        make.right.equalTo(self.addButton.mas_left).offset(-15);
        make.height.equalTo(@30);
    }];
    
    [self.inputView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom);
        make.left.equalTo(self.inputView.mas_left).offset(10);
        make.right.equalTo(self.inputView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    [self.inputView addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.inputView.mas_left).offset(15);
        make.right.equalTo(self.inputView.mas_right).offset(-15);
        make.height.equalTo(@60);
    }];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.inputView.mas_top);
    }];
}

#pragma mark - init
- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
    }
    return _inputView;
}

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setTitle:@"@Me"
                    forState:UIControlStateNormal];
        [_addButton setTitle:@""
                    forState:UIControlStateHighlighted];
        [_addButton setTitleColor:TOMATOCOLOR(216, 30, 6, 1) forState:UIControlStateNormal];
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
        _describeLabel.text = @"红色按钮↓可以快捷输入哦~";
        _describeLabel.textColor = [UIColor grayColor];
        NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:_describeLabel.text];
        NSRange range = [_describeLabel.text rangeOfString:@"↓" options:NSCaseInsensitiveSearch];
        [titleStr addAttribute:NSForegroundColorAttributeName value:TOMATOCOLOR(216, 30, 6, 1) range:range];
        [_describeLabel setAttributedText:titleStr];
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = [UIFont systemFontOfSize:17.0f];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _describeLabel;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.rowHeight = 50;
        _tableview.backgroundColor = [UIColor clearColor];
    }
    return _tableview;
}

#pragma mark - action
- (void)addButtonAction:(UIButton *)sender {
    [self todayAddAction];
}
- (void)todayAddAction {}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self todayTextFieldDidBeginEditing:textField];
}
- (void)todayTextFieldDidBeginEditing:(UITextField *)textField {}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self todayTextFieldShouldBeginEditing:textField];
    return YES;
}
- (BOOL)todayTextFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self todayTextFieldShouldReturn:textField];
    return YES;
}
- (BOOL)todayTextFieldShouldReturn:(UITextField *)textField {
    return YES;
}

@end

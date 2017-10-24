//
//  TodayToolView.m
//  RemindWidget
//
//  Created by lyhao on 2017/10/24.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "TodayToolView.h"
#import <Masonry.h>
#define SW [UIScreen mainScreen].bounds.size.width
#define BTNWIDTH 44

@implementation TodayToolView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SW, BTNWIDTH);
        [self initUI];
    }
    return self;
}

#pragma mark - init
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *recvKeyBoardView = [[UIView alloc] init];
    [self addSubview:recvKeyBoardView];
    [recvKeyBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@BTNWIDTH);
        make.height.equalTo(@BTNWIDTH);
    }];
    recvKeyBoardView.backgroundColor = [UIColor whiteColor];
    recvKeyBoardView.layer.shadowOpacity = 0.2;
    recvKeyBoardView.layer.shadowColor = [UIColor blackColor].CGColor;
    recvKeyBoardView.layer.shadowRadius = 2;
    recvKeyBoardView.layer.shadowOffset = CGSizeMake(2, 0);
    
    UIButton *recvKeyBoardBtn = [[UIButton alloc] init];
    [recvKeyBoardView addSubview:recvKeyBoardBtn];
    [recvKeyBoardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recvKeyBoardView.mas_left);
        make.right.equalTo(recvKeyBoardView.mas_right);
        make.top.equalTo(recvKeyBoardView.mas_top);
        make.bottom.equalTo(recvKeyBoardView.mas_bottom);
    }];
    [recvKeyBoardBtn setBackgroundImage:[UIImage imageNamed:@"dao3"] forState:UIControlStateNormal];
    [recvKeyBoardBtn addTarget:self action:@selector(recvKeyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *thingsLabel = [[UILabel alloc] init];
    [self addSubview:thingsLabel];
    [thingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recvKeyBoardView.mas_right).offset(13);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@BTNWIDTH);
        make.height.equalTo(@BTNWIDTH);
    }];
    thingsLabel.text = @"事项";
    thingsLabel.textColor = [UIColor grayColor];
    thingsLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *separatorBtn = [[UIButton alloc] init];
    [self addSubview:separatorBtn];
    [separatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thingsLabel.mas_right);
        make.top.equalTo(self.mas_top).offset(4);
        make.width.equalTo(@(BTNWIDTH - 8));
        make.height.equalTo(@(BTNWIDTH - 8));
    }];
    [separatorBtn setBackgroundImage:[UIImage imageNamed:@"xie"] forState:UIControlStateNormal];
    [separatorBtn addTarget:self action:@selector(outputSeparator:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *modelBtn = [[UIButton alloc] init];
    [self addSubview:modelBtn];
    [modelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(separatorBtn.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@BTNWIDTH);
        make.height.equalTo(@BTNWIDTH);
    }];
    [modelBtn setTitle:@"每天" forState:UIControlStateNormal];
    [modelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [modelBtn addTarget:self action:@selector(outputEveryDay:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *orLabel = [[UILabel alloc] init];
    [self addSubview:orLabel];
    [orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(modelBtn.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@(BTNWIDTH/2));
        make.height.equalTo(@BTNWIDTH);
    }];
    orLabel.text = @"or";
    orLabel.textColor = [UIColor grayColor];
    orLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *tempBtn = [[UIButton alloc] init];
    [self addSubview:tempBtn];
    [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orLabel.mas_right);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@BTNWIDTH);
        make.height.equalTo(@BTNWIDTH);
    }];
    [tempBtn setTitle:@"临时" forState:UIControlStateNormal];
    [tempBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tempBtn addTarget:self action:@selector(outputTemp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *atBtn = [[UIButton alloc] init];
    [self addSubview:atBtn];
    [atBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempBtn.mas_right).offset(18);
        make.top.equalTo(self.mas_top).offset(9.5);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    [atBtn setBackgroundImage:[UIImage imageNamed:@"at"] forState:UIControlStateNormal];
    [atBtn addTarget:self action:@selector(outputAt:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(atBtn.mas_right).offset(18);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@BTNWIDTH);
        make.height.equalTo(@BTNWIDTH);
    }];
    timeLabel.text = @"时间";
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - action
- (void)recvKeyBoardAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TodayToolView:recvKeyBoardAction:)]) {
        [self.delegate TodayToolView:self recvKeyBoardAction:sender];
    }
}

- (void)outputSeparator:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TodayToolView:outputSeparator:)]) {
        [self.delegate TodayToolView:self outputSeparator:sender];
    }
}

- (void)outputEveryDay:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TodayToolView:outputEveryDay:)]) {
        [self.delegate TodayToolView:self outputEveryDay:sender];
    }
}

- (void)outputTemp:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TodayToolView:outputTemp:)]) {
        [self.delegate TodayToolView:self outputTemp:sender];
    }
}

- (void)outputAt:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TodayToolView:outputAt:)]) {
        [self.delegate TodayToolView:self outputAt:sender];
    }
}

@end

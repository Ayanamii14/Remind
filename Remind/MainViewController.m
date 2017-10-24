//
//  MainViewController.m
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "TomatoViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgGet) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultValueViewStyle];
}

- (void)defaultValueViewStyle {
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)msgGet {
    //把数据得保存起来
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.lyhao.Remind"];
    self.dataArr = [[NSMutableArray alloc] initWithArray:[userDefaults valueForKey:@"note"]];
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"番茄";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TomatoViewController *tVC = [[TomatoViewController alloc] init];
        [self.navigationController pushViewController:tVC animated:YES];
    }
}

@end

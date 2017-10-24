//
//  TomatoViewController.m
//  Remind
//
//  Created by lyhao on 2017/10/23.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "TomatoViewController.h"

#define TOMATOCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface TomatoViewController () <UINavigationControllerDelegate> {
    int left, right, tomato;
    NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UILabel *leftTime;
@property (weak, nonatomic) IBOutlet UILabel *rightTime;
@property (weak, nonatomic) IBOutlet UILabel *tomatoCount;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation TomatoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    tomato = 0;
    [self initUI];
    [self resetTime];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
}

- (void)initUI {
    
}

- (void)resetTime {
    //minuters
    left = 25;
    right = 0;
    self.leftTime.text = left < 10 ? [NSString stringWithFormat:@"0%d", left] : [NSString stringWithFormat:@"%d", left];
    self.rightTime.text = right < 10 ? [NSString stringWithFormat:@"0%d", right] : [NSString stringWithFormat:@"%d", right];
}

- (void)countDown {
    if (tomato <= 4) {
        if (-- right < 0) {
            if (left -- <= 0) {
                [timer invalidate];
                timer = nil;
                [self resetTime];
                self.tomatoCount.text = [NSString stringWithFormat:@"%d", ++tomato];
                self.startBtn.userInteractionEnabled = YES;
                self.startBtn.backgroundColor = TOMATOCOLOR(102, 226, 162, 1);
                return;
            }
            //seconds
            right = 59;
        }
        self.leftTime.text = left < 10 ? [NSString stringWithFormat:@"0%d", left] : [NSString stringWithFormat:@"%d", left];
        self.rightTime.text = right < 10 ? [NSString stringWithFormat:@"0%d", right] : [NSString stringWithFormat:@"%d", right];
    }
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)startAction:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    self.startBtn.userInteractionEnabled = NO;
    self.startBtn.backgroundColor = TOMATOCOLOR(184, 184, 184, 1);
    self.backBtn.hidden = YES;
}

- (IBAction)resetAction:(id)sender {
    [timer invalidate];
    timer = nil;
    [self resetTime];
    self.startBtn.backgroundColor = TOMATOCOLOR(102, 226, 162, 1);
    self.startBtn.userInteractionEnabled = YES;
    self.backBtn.hidden = NO;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end

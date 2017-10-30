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
@property (weak, nonatomic) IBOutlet UILabel *left10Time;
@property (weak, nonatomic) IBOutlet UILabel *left01Time;
@property (weak, nonatomic) IBOutlet UILabel *right10Time;
@property (weak, nonatomic) IBOutlet UILabel *right01Time;
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
    
    //十
    self.left10Time.text = @"2";
    //个
    self.left01Time.text = @"5";
    //十
    self.right10Time.text = @"0";
    //个
    self.right01Time.text = @"0";
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
        //十
        self.left10Time.text = [self divtime:left][0];
        //个
        self.left01Time.text = [self divtime:left][1];
        //十
        self.right10Time.text = [self divtime:right][0];
        //个
        self.right01Time.text = [self divtime:right][1];
    }
}

/**
 返回被划分的时间

 @param time 时间整型
 @return 数组
 */
- (NSArray *)divtime:(NSInteger)time {
    NSMutableArray *muta = [[NSMutableArray alloc] init];
    if (time < 10) {
        [muta addObject:@"0"];
        [muta addObject:[NSString stringWithFormat:@"%ld", time]];
    }
    else {
        [muta addObject:[NSString stringWithFormat:@"%ld", time / 10]];
        [muta addObject:[NSString stringWithFormat:@"%ld", time % 10]];
    }
    return muta;
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - button action
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

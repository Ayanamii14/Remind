//
//  BeginViewController.m
//  Remind
//
//  Created by lyhao on 2017/9/4.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "BeginViewController.h"

#define CircleAnimation @"CircleAnimation"
#define LeftEarAnimation @"LeftEarAnimation"
#define RightEarAnimation @"RightEarAnimation"
#define MinuteAnimation @"MinuteAnimation"
#define HourAnimation @"HourAnimation"
#define POINT self.clockView.bounds.size.width

@interface BeginViewController ()
{
    CAShapeLayer *_circleLayer;
    CAShapeLayer *_leftEarLayer;
    CAShapeLayer *_rightEarLayer;
    CAShapeLayer *_minuteLayer;
    CAShapeLayer *_hourLayer;
}
@property (strong, nonatomic) UIView *clockView;

@end

@implementation BeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    [self actionAnimation];
}

- (void)initUI {
    self.clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    self.clockView.center = self.view.center;
    self.clockView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clockView];
    
    [self addCircle];
    [self addLeftEar];
    [self addRightEar];
    [self addMinute];
    [self addHour];
}

/**
 线条宽度，根据按钮的宽度按比例设置

 @return 线条宽度
 */
- (CGFloat)lineWidth {
    return 0.03 * POINT;
}

- (void)addCircle {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(POINT / 2, POINT / 2) radius:0.3 * POINT startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.path = path.CGPath;
    //填充色
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    //笔画的线条颜色
    _circleLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    //线条宽度
    _circleLayer.lineWidth = [self lineWidth];
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.lineJoin = kCALineJoinRound;
    _circleLayer.strokeEnd = 0;
    [self.clockView.layer addSublayer:_circleLayer];
}

- (void)addLeftEar {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.1 * POINT, 0.25 * POINT)];
    [path addLineToPoint:CGPointMake(0.25 * POINT, 0.1 * POINT)];
    
    _leftEarLayer = [CAShapeLayer layer];
    _leftEarLayer.path = path.CGPath;
    _leftEarLayer.fillColor = [UIColor clearColor].CGColor;
    _leftEarLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _leftEarLayer.lineWidth = [self lineWidth];
    _leftEarLayer.lineCap = kCALineCapRound;
    _leftEarLayer.lineJoin = kCALineJoinRound;
    _leftEarLayer.strokeEnd = 0;
    [self.clockView.layer addSublayer:_leftEarLayer];
}

- (void)addRightEar {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.75 * POINT, 0.1 * POINT)];
    [path addLineToPoint:CGPointMake(0.9 * POINT, 0.25 * POINT)];
    
    _rightEarLayer = [CAShapeLayer layer];
    _rightEarLayer.path = path.CGPath;
    _rightEarLayer.fillColor = [UIColor clearColor].CGColor;
    _rightEarLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _rightEarLayer.lineWidth = [self lineWidth];
    _rightEarLayer.lineCap = kCALineCapRound;
    _rightEarLayer.lineJoin = kCALineJoinRound;
    _rightEarLayer.strokeEnd = 0;
    [self.clockView.layer addSublayer:_rightEarLayer];
}

- (void)addMinute {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint p = [self getEndPointWithClockDateComponents:ClockDateComponentsMinute];
    [path moveToPoint:CGPointMake(POINT / 2, POINT / 2)];
    [path addLineToPoint:p];
    
    _minuteLayer = [CAShapeLayer layer];
    _minuteLayer.path = path.CGPath;
    _minuteLayer.fillColor = [UIColor clearColor].CGColor;
    _minuteLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _minuteLayer.lineWidth = [self lineWidth];
    _minuteLayer.lineCap = kCALineCapRound;
    _minuteLayer.lineJoin = kCALineJoinRound;
    _minuteLayer.strokeEnd = 0;
    [self.clockView.layer addSublayer:_minuteLayer];
}

- (void)addHour {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint p = [self getEndPointWithClockDateComponents:ClockDateComponentsHour];
    [path moveToPoint:CGPointMake(POINT / 2, POINT / 2)];
    [path addLineToPoint:p];
    
    _hourLayer = [CAShapeLayer layer];
    _hourLayer.path = path.CGPath;
    _hourLayer.fillColor = [UIColor clearColor].CGColor;
    _hourLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _hourLayer.lineWidth = [self lineWidth];
    _hourLayer.lineCap = kCALineCapRound;
    _hourLayer.lineJoin = kCALineJoinRound;
    _hourLayer.strokeEnd = 0;
    [self.clockView.layer addSublayer:_hourLayer];
}

- (void)actionAnimation {
    /*
     GCD的队列组
     dispatch_group_t group =  dispatch_group_create();
     
     dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // 执行1个耗时的异步操作
     });
     
     dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // 执行1个耗时的异步操作
     });
     
     dispatch_group_notify(group, dispatch_get_main_queue(), ^{
     // 等前面的异步操作都执行完毕后，回到主线程...
     });
     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self strokeEndAnimationFrom:0
                                  to:1
                             onLayer:_circleLayer
                                name:CircleAnimation
                            duration:2
                            delegate:nil];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self strokeEndAnimationFrom:0
                                  to:1
                             onLayer:_leftEarLayer
                                name:LeftEarAnimation
                            duration:2
                            delegate:nil];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self strokeEndAnimationFrom:0
                                  to:1
                             onLayer:_rightEarLayer
                                name:RightEarAnimation
                            duration:2
                            delegate:nil];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self strokeEndAnimationFrom:0
                                  to:1
                             onLayer:_minuteLayer
                                name:MinuteAnimation
                            duration:2
                            delegate:nil];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self strokeEndAnimationFrom:0
                                  to:1
                             onLayer:_hourLayer
                                name:HourAnimation
                            duration:2
                            delegate:nil];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  3.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            if (self.finish) {
                self.finish();
            }
        });
    });
}

/**
 通用执行strokeEnd动画
 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString*)animationName duration:(CGFloat)duration delegate:(id)delegate{
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = delegate;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}

- (NSDateComponents *)getCurrentTime {
    NSTimeZone *tZone = [NSTimeZone localTimeZone];
    //获取日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    [calendar setTimeZone:tZone];
    NSDateComponents *currentTime = [calendar components:NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitTimeZone fromDate:currentDate];
    return currentTime;
}

#pragma mark - 根据当前时间来确定时针，分针所指向的位置
- (CGPoint)getEndPointWithClockDateComponents:(ClockDateComponents)clockDateComponents{
    CGPoint point;
    CGFloat radian;
    CGFloat x = 0.0,y = 0.0,r = 0.0;
    NSDateComponents *date = [self getCurrentTime];
    if (clockDateComponents == ClockDateComponentsMinute) {
        radian = (M_PI * 2 / 60) * date.minute;
        r = POINT / 4;
    }
    else {
        //12小时制
        CGFloat hour = 0;
        if (date.hour > 12) {
            hour = date.hour - 12;
        }
        else {
            hour = date.hour;
        }
        radian = (M_PI * 2 / 12) * hour;
        r = POINT / 6;
    }
    CGFloat halfWidth = POINT / 2;
    
    x = halfWidth + sin(radian) * r;
    y = halfWidth - cos(radian) * r;
    
    point.x = x;
    point.y = y;
    return point;
}

- (void)dealloc {
    
}

@end

//
//  AppDelegate.m
//  Remind
//
//  Created by lyhao on 2017/8/3.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "AppDelegate.h"
#import "BeginViewController.h"
#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>

#ifdef DEBUG
    #import "TXFPSCalculator.h"
#endif

extern CFAbsoluteTime StartTime;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #ifdef DEBUG
        //帧数计算
//        [[TXFPSCalculator calculator] start];
    #endif
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //从其他页面跳转到时
    if (launchOptions) {
        MainViewController *mainVC = [[MainViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        self.window.rootViewController = nav;
    }
    else {
        [self launchAnimation];
    }
    [self.window makeKeyAndVisible];
    
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 点击允许
            NSLog(@"注册成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        } else {
            // 点击不允许
            NSLog(@"注册失败");
        }
    }];
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)launchAnimation {
    BeginViewController *beginVC = [[BeginViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    beginVC.finish = ^{
        MainViewController *mainVC = [[MainViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        weakSelf.window.rootViewController = nav;
    };
    self.window.rootViewController = beginVC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber --;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    application.applicationIconBadgeNumber --;
}

@end

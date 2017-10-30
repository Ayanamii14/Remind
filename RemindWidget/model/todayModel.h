//
//  todayModel.h
//  RemindWidget
//
//  Created by lyhao on 2017/10/26.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface todayModel : NSObject <NSCoding>

@property (strong, nonatomic) NSArray *remindStr;
@property (assign, nonatomic) BOOL isComeTrue;

@end

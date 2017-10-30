//
//  todayModel.m
//  RemindWidget
//
//  Created by lyhao on 2017/10/26.
//  Copyright © 2017年 lyhao. All rights reserved.
//

#import "todayModel.h"

@implementation todayModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.remindStr = [aDecoder decodeObjectForKey:@"remindStr"];
        self.isComeTrue = [aDecoder decodeObjectForKey:@"isComeTrue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.remindStr forKey:@"remindStr"];
    [aCoder encodeBool:self.isComeTrue forKey:@"isComeTrue"];
}

@end

//
//  Register.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/7.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "Register.h"

@implementation Register

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.username = @"";
        self.type = @"register";
    }
    return self;
}

- (NSDictionary *)toParams{
    return @{@"user.username" : self.username,
             @"type" :self.type};
}

@end

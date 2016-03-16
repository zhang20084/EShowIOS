//
//  Login.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/7.
//  Copyright © 2016年 金璟. All rights reserved.
//

#define kLoginPreUserEmail @"pre_user_name"

#import "Login.h"

@implementation Login

+ (void)setPreUserName:(NSString *)NameStr{
    if (NameStr.length <= 0) {
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:NameStr forKey:kLoginPreUserEmail];
    [defaults synchronize];
}

@end

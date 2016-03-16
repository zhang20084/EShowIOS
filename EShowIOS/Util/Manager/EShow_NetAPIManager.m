//
//  EShow_NetAPIManager.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/8.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "EShow_NetAPIManager.h"

@implementation EShow_NetAPIManager

+ (instancetype)sharedManager {
    static EShow_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)request_Register_WithParams:(id)params andBlock:(void (^)(id data, NSError *error))block{
    [[EShowNetAPIClient sharedJsonClient] requestJsonDataWithPath:@"user/login.json" withParams:params withMethodType:Post andBlock:^(id data,NSError *error){
    
    }];
}

@end

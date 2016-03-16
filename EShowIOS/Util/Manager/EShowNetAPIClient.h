//
//  EShowNetAPIClient.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/8.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NSObject+commom.h"

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface EShowNetAPIClient : AFHTTPRequestOperationManager

+ (id)sharedJsonClient;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

@end

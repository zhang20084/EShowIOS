//
//  EShow_NetAPIManager.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/8.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EShowNetAPIClient.h"

@interface EShow_NetAPIManager : NSObject
+ (instancetype)sharedManager;

//login
- (void)request_Register_WithParams:(id)params andBlock:(void (^)(id data, NSError *error))block;
@end

//
//  FRAppAgent.h
//
//  Copyright (c) 2014 Testin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CrashMasterConfig.h"

@interface CrashMaster : NSObject

+ (void)init:(NSString *)appId;
+ (void)init:(NSString *)appId channel:(NSString *)channel;
+ (void)init:(NSString *)appId channel:(NSString *)channel config:(CrashMasterConfig*)config;
+ (void)init:(NSString *)appId groupId:(NSString *)groupId channel:(NSString *)channel config:(CrashMasterConfig *)config;

+ (void)setUserInfo:(NSString *)userInfo;

+ (void)reportCustomizedException:(NSException *)exception message:(NSString *)message;
+ (void)reportCustomizedException:(NSNumber *)type message:(NSString *)message stackTrace:(NSString *)stackTrace;

+ (void)leaveBreadcrumbWithString:(NSString*)string;
+ (void)leaveBreadcrumbWithFormat:(NSString *)format, ...;

+ (void)terminate;

@end


//
//  TestinConfig.h
//  TestinmAPM
//
//  Created by maximli on 15/4/20.
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestinDelegate.h"
#import "TestinLog.h"

#if XCODE_VER_6_4

#   define NONNULL       _Nonnull
#   define NULLABLE      _Nullable

#else

#   define NONNULL
#   define NULLABLE

#endif

@interface TestinConfig : NSObject
{
    __unsafe_unretained id testinDelegate_;
}

// delegate.
@property(nonatomic, assign) id<TestinDelegate> testinDelegate;

// NSURLConnection monitor enabled, default YES.
@property(nonatomic, assign) BOOL collectorNSURLConnection;

// NSURLSession monitor enabled, default NO.
@property(nonatomic, assign) BOOL collectorNSURLSession;

// Exception monitor enabled, default YES.
@property(nonatomic, assign) BOOL enabledMonitorException;

// use user location info, default NO.
@property(nonatomic, assign) BOOL useLocationInfo;

// use https, default YES.
@property(nonatomic, assign) BOOL useSecurityHttpConnection;

// only wifi report data, default YES.
@property(nonatomic, assign) BOOL reportOnlyWIFI;

// set upload log level, default 0 nothing.
@property(nonatomic, assign) NSInteger uploadLogLevel;

// print log in simulator for debug, default NO.
@property(nonatomic, assign) BOOL printLogForDebug;


+ (TestinConfig*)defaultConfig;

@end

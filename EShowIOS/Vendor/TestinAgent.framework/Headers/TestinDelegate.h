//
//  TestinDelegate.h
//  TestinmAPM
//
//  Created by maximli on 15/5/22.
//  Copyright (c) 2015年 testin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestinDelegate <NSObject>

@optional

- (void)testinReceivedCrashNotification:(NSString*)stackTrace;

@end

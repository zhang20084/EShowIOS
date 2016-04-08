//
//  LNSearchManager.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LNLocationGeocoder.h"

@interface LNSearchManager : NSObject

@property (nonatomic, strong) CLGeocoder *gecoder;

@property (nonatomic, copy) void (^completionBlock)(LNLocationGeocoder *locationGeocoder,NSError *error);

- (void)startReverseGeocode:(CLLocation*)location completeionBlock:(void(^)(LNLocationGeocoder *locationGeocoder,NSError *error))completeion;

@end
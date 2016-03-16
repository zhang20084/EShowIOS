//
//  LNLocationManager.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LNLocationManager : UIView<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) void (^startBlock)(void);

@property (nonatomic, copy) void (^successCompletionBlock)(CLLocation *location);

@property (nonatomic, copy) void (^failureCompletionBlock)(CLLocation *location,NSError *error);


- (void)startWithBlock:(void(^)(void))start
       completionBlock:(void(^)(CLLocation *location))success
               failure:(void(^)(CLLocation *location, NSError *error))failure;

@end
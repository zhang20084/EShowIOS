//
//  LNLocationManager.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "LNLocationManager.h"

static CLLocation *oldLocation;

@implementation LNLocationManager

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startWithBlock:(void (^)(void))start completionBlock:(void (^)(CLLocation *))success failure:(void (^)(CLLocation *, NSError *))failure{
    [self setStartBlock:start completionBlock:success failure:failure];
    [self startLocation];
}


- (void)setStartBlock:(void(^)(void))start completionBlock:(void(^)(CLLocation*))success failure:(void (^)(CLLocation *, NSError *))failure{
    self.startBlock = start;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}


- (void)startLocation{
    self.startBlock();
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManager Delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.loactionManager stopUpdatingLocation];
    oldLocation = [locations lastObject];
    self.successCompletionBlock(oldLocation);
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.failureCompletionBlock(oldLocation,error);
}


#pragma mark - Getter and Setter
- (CLLocationManager*)loactionManager{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}


@end
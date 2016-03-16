//
//  LNSearchManager.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "LNSearchManager.h"

@implementation LNSearchManager

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startReverseGeocode:(CLLocation *)location completeionBlock:(void (^)(LNLocationGeocoder *, NSError *))completeion{
    self.completionBlock = completeion;
    [self startReverseGeocode:location];
}

- (void)startReverseGeocode:(CLLocation *)location{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            self.completionBlock(nil,error);
        }else{
            LNLocationGeocoder *locationGeocoder = [[LNLocationGeocoder alloc] init];
            CLPlacemark *placemark = [placemarks firstObject];
            NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
            
            locationGeocoder.formatterAddress = dictionary[@"Name"];
            locationGeocoder.province = dictionary[@"State"];
            locationGeocoder.city = dictionary[@"City"];
            locationGeocoder.district = dictionary[@"SubLocality"];
            locationGeocoder.locality = placemark.locality;
            self.completionBlock(locationGeocoder,nil);
        }
    }];
}


#pragma mark - Getter and Setter
- (CLGeocoder*)gecoder{
    if (_gecoder == nil) {
        _gecoder = [[CLGeocoder alloc] init];
    }
    return _gecoder;
}

@end
//
//  CurrentCityCell.h
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLocationManager.h"
#import "LNSearchManager.h"

@interface CurrentCityCell : UITableViewCell

@property (nonatomic, strong) UIButton *GPSButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) LNLocationManager *locationManager;

@property (nonatomic, strong) LNSearchManager *searchManager;

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *button);

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
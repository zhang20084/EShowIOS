//
//  BHotCityCell.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCityCell : UITableViewCell

@property (nonatomic,copy) void (^buttonClickBlock)(UIButton *);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray*)cities;

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
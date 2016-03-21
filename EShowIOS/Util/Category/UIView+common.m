//
//  UIView+common.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/18.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "UIView+common.h"

@implementation UIView_common

- (void)doCircleFrame{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
}

@end

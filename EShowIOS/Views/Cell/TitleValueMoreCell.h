//
//  TitleValueMoreCell.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/25.
//  Copyright © 2016年 金璟. All rights reserved.
//
#define kCellIdentifier_TitleValueMore @"TitleValueMoreCell"

#import <UIKit/UIKit.h>

@interface TitleValueMoreCell : UITableViewCell
- (void)setTitleStr:(NSString *)title valueStr:(NSString *)value;
+ (CGFloat)cellHeight;
@end

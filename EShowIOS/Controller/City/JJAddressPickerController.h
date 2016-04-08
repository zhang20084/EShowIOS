//
//  JJAddressPickerController.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJAddressPickerController;

@protocol JJAddressPickerDataSource <NSObject>

@required
- (NSArray*)arrayOfHotCitiesInAddressPicker:(JJAddressPickerController*)addressPicker;

@end

@protocol JJAddressPickerDelegate <NSObject>

-(void)addressPicker:(JJAddressPickerController*)addressPicker didSelectedCity:(NSString*)city;

- (void)beginSearch:(UISearchBar*)searchBar;

- (void)endSearch:(UISearchBar*)searchBar;

@end

@interface JJAddressPickerController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//数据源代理协议
@property (nonatomic, weak) id<JJAddressPickerDataSource> dataSource;
//委托代理协议
@property (nonatomic, weak) id<JJAddressPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
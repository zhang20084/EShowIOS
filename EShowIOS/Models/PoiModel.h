//
//  PoiModel.h
//  EShowIOS
//
//  Created by 金璟 on 16/4/17.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoiModel : NSObject

@property (nonatomic, copy)   NSString     *uid; //!< POI全局唯一ID
@property (nonatomic, copy)   NSString     *name; //!< 名称
@property (nonatomic, copy)   NSString     *type; //!< 兴趣点类型
@property (nonatomic, copy)   NSString     *address;  //!< 地址
@property (nonatomic, copy)   NSString     *tel;  //!< 电话
@property (nonatomic, assign) NSInteger     distance; //!< 距中心点距离，仅在周边搜索时有效
@property (nonatomic, copy)   NSString     *parkingType; // !< 停车场类型，地上、地下、路边

// 扩展信息
@property (nonatomic, copy)   NSString     *postcode; //!< 邮编
@property (nonatomic, copy)   NSString     *website; //!< 网址
@property (nonatomic, copy)   NSString     *email;    //!< 电子邮件
@property (nonatomic, copy)   NSString     *province; //!< 省
@property (nonatomic, copy)   NSString     *pcode;   //!< 省编码
@property (nonatomic, copy)   NSString     *city; //!< 城市名称
@property (nonatomic, copy)   NSString     *citycode; //!< 城市编码
@property (nonatomic, copy)   NSString     *district; //!< 区域名称
@property (nonatomic, copy)   NSString     *adcode;   //!< 区域编码
@property (nonatomic, copy)   NSString     *gridcode; //!< 地理格ID
@property (nonatomic, copy)   NSString     *direction; //!< 方向
@property (nonatomic, assign) BOOL          hasIndoorMap; //!< 是否有室内地图
@property (nonatomic, copy)   NSString     *businessArea; //!< 所在商圈
@property (nonatomic, strong) NSArray      *subPOIs; // !< 子POI列表 AMapSubPOI 数组

@end

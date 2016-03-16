//
//  Register.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/7.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Register : NSObject

@property (nonatomic , strong , readwrite) NSString *username, *type;

- (NSDictionary *)toParams;
@end

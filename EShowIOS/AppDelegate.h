//
//  AppDelegate.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/1.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupTabViewController;
- (void)setupLoginViewController;
- (void)setupIntroductionViewController;

@end


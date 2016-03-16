//
//  AppDelegate.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/1.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "IntroductionViewController.h"
#import "LoginViewController.h"
#import "RootTabViewController.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    //设置友盟AppKey
    [UMSocialData setAppKey:@"56ceca68e0f55a2ece000d68"];
    
    
    //友盟第三方登录
    [UMSocialQQHandler setQQWithAppId:@"1105243226" appKey:@"4HxQ7MMmThRlaIXu" url:nil];
    [UMSocialWechatHandler setWXAppId:@"wxe0304d6eff6e6307" appSecret:@"7c769ad88fcd6dd6b4a6f7c2a8f5426e" url:nil];
    
    //设置导航条样式
    [self customizeInterface];
    
    [self setupIntroductionViewController];
//    [self setupTabViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Methods Private
- (void)setupTabViewController{
    RootTabViewController *rootVC = [[RootTabViewController alloc] init];
    [self.window setRootViewController:rootVC];
}

- (void)setupLoginViewController{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.window setRootViewController:[[BaseNavigationController alloc] initWithRootViewController:loginVC]];
}

- (void)setupIntroductionViewController{
    IntroductionViewController *introductionVC = [[IntroductionViewController alloc] init];
    [self.window setRootViewController:introductionVC];
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundColor:[UIColor whiteColor]];
    [navigationBarAppearance setTintColor:[UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end

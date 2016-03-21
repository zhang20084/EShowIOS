//
//  BaseRDVTabViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/17.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "BaseRDVTabViewController.h"
#import "RDVFirstViewController.h"
#import "RDVSecondViewController.h"
#import "RDVThirdViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

@interface BaseRDVTabViewController ()

@end

@implementation BaseRDVTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"信息表单";
    
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {

    RDVFirstViewController *First_vc = [[RDVFirstViewController alloc] init];
    UINavigationController *nav_First = [[BaseNavigationController alloc] initWithRootViewController:First_vc];
    
    RDVSecondViewController *second_vc = [[RDVSecondViewController alloc] init];
    UINavigationController *nav_second = [[BaseNavigationController alloc] initWithRootViewController:second_vc];
    
    RDVThirdViewController *Third_vc = [[RDVThirdViewController alloc] init];
    UINavigationController *nav_Third = [[BaseNavigationController alloc] initWithRootViewController:Third_vc];
    
    [self setViewControllers:@[nav_First,nav_second,nav_Third]];
    
    [self customizeTabBarForController];
    
    self.delegate =self;
}

- (void)customizeTabBarForController{
    
    UIImage *back_image = [UIImage imageNamed:@"tabbar_background"];
//    NSArray *tabBar_image = @[@"First",@"Second",@"Third"];
    NSArray *tabBar_image_unselected = @[@"First_un",@"Second_un",@"Third_un"];
    NSArray *tabBar_title = @[@"基本信息",@"个人信息",@"账号绑定"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:back_image withUnselectedImage:back_image];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBar_image_unselected objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBar_image_unselected objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBar_title objectAtIndex:index]];
        index ++;
    }
}

#pragma mark RDVTabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedViewController != viewController) {
        return YES;
    }
    if (![viewController isKindOfClass:[UINavigationController class]]) {
        return YES;
    }
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.topViewController != nav.viewControllers[0]) {
        return YES;
    }
    return YES;
}
@end

//
//  BaseRDVTabViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/17.
//  Copyright © 2016年 金璟. All rights reserved.
//
#define VString(x)      NSLocalizedString(x, nil)

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
    
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)setupViewControllers {

    RDVFirstViewController *First_vc = [[RDVFirstViewController alloc] init];
    UINavigationController *nav_First = [[BaseNavigationController alloc] initWithRootViewController:First_vc];
    
    RDVSecondViewController *Second_vc = [[RDVSecondViewController alloc] init];
    UINavigationController *nav_second = [[BaseNavigationController alloc] initWithRootViewController:Second_vc];
    
    RDVThirdViewController *Third_vc = [[RDVThirdViewController alloc] init];
    UINavigationController *nav_Third = [[BaseNavigationController alloc] initWithRootViewController:Third_vc];

    First_vc.title = VString(@"基本信息");
    Second_vc.title = VString(@"个人信息");
    Third_vc.title = VString(@"账号绑定");
    
    [self setViewControllers:@[nav_First,nav_second,nav_Third]];

    [self customizeTabBarForController];
    
}

- (void)customizeTabBarForController{

    UIImage *backgroundImage = [UIImage imageNamed:@"tabbar_background"];
    //选项卡图片
    NSArray *tabBarItemImages = @[VString(@"First"), VString(@"Second"),VString(@"Third")];;
    
    NSArray *tabBarItemTitles = @[VString(@"基本信息"), VString(@"个人信息"), VString(@"账号绑定")];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items])
    {
        item.titlePositionAdjustment = UIOffsetMake(0, 2.0);
        [item setBackgroundSelectedImage:backgroundImage withUnselectedImage:backgroundImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",[tabBarItemImages objectAtIndex:index]]];
        
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
        
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

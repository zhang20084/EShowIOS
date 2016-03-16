//
//  RootTabViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/2.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RootTabViewController.h"
#import "LeftViewController.h"
#import "CenterTableViewController.h"

@interface RootTabViewController ()
@property (nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maximumLeftDrawerWidth = (ScreenWidth*2.5)/4;
    self.shouldStretchDrawer = NO;
    self.showsShadow = YES;
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDrawer) name:OpenDrawer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeDrawer) name:CloseDrawer object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleDrawer) name:ToggleDrawer object:nil];
    
     LeftViewController *drawerController = [[LeftViewController alloc] init];
    
    self.leftDrawerViewController = drawerController;

    
    UIViewController *centerViewController = [[CenterTableViewController alloc] init];
    
    UINavigationController * navigationController = [[BaseNavigationController alloc] initWithRootViewController:centerViewController];
    
//    self.drawerController = [[MMDrawerController alloc]
//                             initWithCenterViewController:navigationController
//                             leftDrawerViewController:leftSideNavController];
    
    self.centerViewController = navigationController;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openDrawer {
    [self openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)closeDrawer {
    [self closeDrawerAnimated:YES completion:nil];
    
}

- (void)toggleDrawer {
    if (self.openSide == MMDrawerSideNone) {
        [self openDrawer];
    } else {
        [self closeDrawer];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

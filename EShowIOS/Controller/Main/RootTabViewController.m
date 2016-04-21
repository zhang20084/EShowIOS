//
//  RootTabViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/19.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RootTabViewController.h"
#import "ContentViewController.h"
#import "SideMenuViewController.h"

@interface RootTabViewController ()

@end

@implementation RootTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {
    
    self.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ContentViewController alloc]init]];
    self.leftPanel = [[SideMenuViewController alloc] init];
    
}

@end

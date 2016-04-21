//
//  SideMenuViewController.m
//  鸽子
//
//  Created by 金璟 on 16/3/31.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "SideMenuViewController.h"

#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "ForgetTelephoneViewController.h"
#import "ContentViewController.h"
#import "PersonalInformationViewController.h"

#import "UIImageView+WebCache.h"

@interface SideMenuViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) UITableView *myTableView;
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_bg"]];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewCell
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
    [cell setSelectedBackgroundView:selectedBackground];
    
    if (indexPath.section == 0) {
        
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(20, 15, 90, 90);
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 10;
        [cell.contentView addSubview:image];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(120, 30, 200, 60);
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *isLogin = [userDefault objectForKey:@"user.username"];
        
        if (isLogin == nil) {
            NSLog(@"%@",isLogin);
            cell.imageView.image = [UIImage imageNamed:@"ic_default_user"];
            cell.textLabel.text = @"注册/登录";
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:22];
        }else{
            [image sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"user.photo"]]];
            label.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user.username"]];
        }
        
    }else{
        
        cell.imageView.image = [UIImage imageNamed:@[@"nav_icon_home",@"nav_icon_setting", @"nav_icon_password"][indexPath.row]];
        cell.textLabel.text = @[@"我的首页",@"系统设置", @"密码修改"][indexPath.row];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:22];
    }

    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.2f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *isLogin = [userDefault objectForKey:@"user.username"];
            
            if (isLogin == nil) {
                NSLog(@"%@",isLogin);
                self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            }else{
                self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[PersonalInformationViewController alloc] init] ];
            }
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
          
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ContentViewController alloc] init]];
            
        }else if (indexPath.row == 1){
            
        self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[SettingViewController alloc] init]];
            
        }else {
            
            self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[ForgetTelephoneViewController alloc] init]];
            
        }
    }
}

@end

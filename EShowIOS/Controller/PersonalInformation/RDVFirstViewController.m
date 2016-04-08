//
//  RDVFirstViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/17.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RDVFirstViewController.h"
#import "JDStatusBarNotification.h"
#import "TitleRImageMoreCell.h"
#import "TitleValueMoreCell.h"
#import "JDStatusBarNotification.h"//小标题
#import "SettingTextViewController.h"

#import "AFNetworking.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

@interface RDVFirstViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation RDVFirstViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    // 马上进入刷新状态
    [_myTableView.mj_header beginRefreshing];
}

- (void) updateView
{
    [_myTableView reloadData];
}
/**
 *  停止刷新
 */
-(void)endRefresh{
    [_myTableView.mj_header endRefreshing];
    [_myTableView.mj_header endRefreshing];
}
/**
 *  更新数据.
 *
 *  数据更新后,会自动更新视图.
 */

- (void)updateData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    NSString * urlStr = [NSString stringWithFormat: @""];
    
    [manager GET: [NSString stringWithFormat:@"%@user/login.json?",BaseUrl]
             parameters:@{
                          @"user.password" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user.password"],
                          @"user.username" : [[NSUserDefaults standardUserDefaults] objectForKey:@"user.username"],
                         }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self endRefresh];
        
        [self updateView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"您的网络不给力!";
        [hud hide: YES afterDelay: 2];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"基本信息";
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0f / 255.0f) green:(247.0f / 255.0f) blue:(240.0f / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[TitleRImageMoreCell class] forCellReuseIdentifier:kCellIdentifier_TitleRImageMore];
        [tableView registerClass:[TitleValueMoreCell class] forCellReuseIdentifier:kCellIdentifier_TitleValueMore];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.myTableView = nil;
    self.view = nil;
}

#pragma mark tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cellHeight = [TitleRImageMoreCell cellHeight];
    }else{
        cellHeight = [TitleValueMoreCell cellHeight];
    }
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        TitleRImageMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleRImageMore forIndexPath:indexPath];
        
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return cell;
    }else{
        TitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleValueMore forIndexPath:indexPath];
        switch (indexPath.row) {
            case 1:{
                NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.username"];
                [cell setTitleStr:@"账号:" valueStr:username];
                break;
            }
            case 2:
            {
                NSString *realname = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.realname"];
                [cell setTitleStr:@"姓名:" valueStr:realname];
                break;
            }
            case 3:
            {
                NSString *nickname = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.nickname"];
                [cell setTitleStr:@"昵称:" valueStr:nickname];
                break;
            }
            case 4:
            {
                NSString *age = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.age"];
                [cell setTitleStr:@"年龄:" valueStr:age];
                break;
            }
            
            default:
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"user.male"]) {
                    [cell setTitleStr:@"性别:" valueStr:@"男"];
                }else{
                    [cell setTitleStr:@"性别:" valueStr:@"女"];
                }
                break;
            }
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if (![JDStatusBarNotification isVisible]) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
                [actionSheet showInView:self.view];
            }
            break;
        }
        case 3:
        {
            SettingTextViewController *vc = [[SettingTextViewController alloc] init];
            vc.setData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user.nickname"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}

@end

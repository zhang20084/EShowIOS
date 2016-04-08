//
//  SettingViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/5.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "SettingViewController.h"
#import "TitleDisclosureCell.h"
#import "WebViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = ColorTableSectionBg;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[TitleDisclosureCell class] forCellReuseIdentifier:kCellIdentifier_TitleDisclosure];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    switch (section) {
        case 0:
            row = 2;
            break;
            
        default:
            row = 2;
            break;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleDisclosureCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleDisclosure forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell setTitleStr:@"意见反馈"];
        }else{
            [cell setTitleStr:@"常见问题"];
        }
    }else{
    
        if (indexPath.row == 0) {
            [cell setTitleStr:@"关于我们"];
        }else{
            [cell setTitleStr:@"欢迎页"];
        }
    }
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    headerView.backgroundColor = ColorTableSectionBg;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    WebViewController *web_vc = [[WebViewController alloc] init];
                    web_vc.titleText = @"意见反馈";
                    NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/feedback"];
                    web_vc.urlString = str;
                    [self.navigationController pushViewController:web_vc animated:YES];
                    
                    break;
                }
                    
                default:
                {
                    WebViewController *question_vc = [[WebViewController alloc] init];
                    question_vc.titleText = @"常见问题";
                    NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/question"];
                    question_vc.urlString = str;
                    [self.navigationController pushViewController:question_vc animated:YES];
                }
                    break;
            }
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    WebViewController *about_vc = [[WebViewController alloc] init];
                    about_vc.titleText = @"关于我们";
                    NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/info/about"];
                    about_vc.urlString = str;
                    [self.navigationController pushViewController:about_vc animated:YES];
                }
                    break;
                    
                default:
                    
                    break;
            }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

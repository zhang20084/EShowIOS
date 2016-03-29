//
//  RDVSecondViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/17.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RDVSecondViewController.h"
#import "TitleValueMoreCell.h"
#import "JDStatusBarNotification.h"

@interface RDVSecondViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) UITableView *myTableView;
@end

@implementation RDVSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0f / 255.0f) green:(247.0f / 255.0f) blue:(240.0f / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TitleValueMoreCell cellHeight];
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
    if (indexPath.section == 0) {
        TitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleValueMore forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
            {
                NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.username"];
                [cell setTitleStr:@"手机号码:" valueStr:username];
                break;
            }
            case 1:
            {
                NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.email"];
                [cell setTitleStr:@"电子邮件:" valueStr:email];
                break;
            }
            case 2:
            {
                NSString *birthday = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.birthday"];
                [cell setTitleStr:@"出生日期:" valueStr:birthday];
                break;
            }
            
            default:
            {
                [cell setTitleStr:@"常住城市" valueStr:@"请选择"];
                break;
            }
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return cell;
    }else{
        TitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleValueMore forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
            {
                NSString *intro = [[NSUserDefaults standardUserDefaults] stringForKey:@"user.intro"];
                [cell setTitleStr:@"个性标签:" valueStr:intro];
                break;
            }
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
                break;
            }
            case 1:
            {
                
                break;
            }
            case 2:
            {
                
                break;
            }
            default:
                break;
        }
    }
    
}
@end

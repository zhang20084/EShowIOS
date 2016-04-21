//
//  SettingTextViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/29.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "SettingTextViewController.h"
#import "AFNetworking.h"

@interface SettingTextViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation SettingTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息修改";
    
    // Do any additional setup after loading the view.
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0f / 255.0f) green:(247.0f / 255.0f) blue:(240.0f / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo (self.view);
        }];
        tableView;
    });
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendUp)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
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
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(20, 0, ScreenWidth - 30.0, 44.0);
        _textField.keyboardType = UIKeyboardTypeEmailAddress;
        _textField.placeholder = @"请输入";
        _textField.text = [NSString stringWithFormat:@"%@",_setData];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_textField];
    }
    
    return cell;
}


- (void)sendUp
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/update.json?",BaseUrl]
             parameters:@{
                          @"accessToken" : [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenLogin"],
                          @"user.photo" : @"",
                          @"user.intro" : @"",
                          @"user.birthday" : @"",
                          @"user.male" : @"",
                          @"user.email" : @"",
                          @"user.nickname" : [NSString stringWithFormat:@"%@",_setData],
                          }
                           success:^(AFHTTPRequestOperation *operation,id responseObject){
                          
                               NSDictionary *dic = responseObject;
                               
                               NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
                               
                               NSLog(@"显示数据:%@",str);
                               
                               if (dic[@"status"] == nil) {
                                   return;
                               }else if ([dic[@"status"] intValue] == 1){
                               
                                   [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                               
                                   [self.navigationController popViewControllerAnimated:YES];
                                   
                               }else{
                               
                                   [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                   
                               }
                               
                          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              NSLog(@"error: %@", error);
                              
                          }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end

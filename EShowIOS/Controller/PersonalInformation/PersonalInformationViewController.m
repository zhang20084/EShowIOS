//
//  PersonalInformationViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/4.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "PersonalInformationViewController.h"
#import "TitleRImageMoreCell.h"
#import "TitleValueMoreCell.h"
#import "JDStatusBarNotification.h"
#import "SettingTextViewController.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+Helper.h"
#import "AddressManager.h"

@interface PersonalInformationViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) NSString *address;

@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"信息表单";
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row;
    if (section == 0) {
        row = 6;
    }else if (section == 1){
        row = 4;
    }else{
        row = 2;
    }
    return row;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
    }else if (indexPath.section == 1){
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
                [cell setTitleStr:@"微信账号:" valueStr:@""];
                break;
            }
            default:
            {
                [cell setTitleStr:@"QQ帐号" valueStr:@""];
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
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 2){
            SettingTextViewController *vc = [[SettingTextViewController alloc] init];
            vc.setData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user.realname"];
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 3){
            SettingTextViewController *vc = [[SettingTextViewController alloc] init];
            vc.setData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user.nickname"];
            [self.navigationController pushViewController:vc animated:YES];

        }else if (indexPath.row == 4){
            
            SettingTextViewController *vc = [[SettingTextViewController alloc] init];
            vc.setData = [[NSUserDefaults standardUserDefaults] objectForKey:@"user.age"];
            [self.navigationController pushViewController:vc animated:YES];
        
        }else {
        
        
        }
    }else if (indexPath.section == 1){
    
        if (indexPath.row == 2) {
            NSDate *curDate = [NSDate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user.birthday"] withFormat:@"yyyy-MM-dd"];
            if (!curDate) {
                curDate = [NSDate dateFromString:@"1990-01-01" withFormat:@"yyyy-MM-dd"];
            }
            ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {

            } cancelBlock:^(ActionSheetDatePicker *picker) {

            } origin:self.view];
            picker.minimumDate = [NSDate date];
            picker.maximumDate = [NSDate date];
            [picker showActionSheetPicker];
        
        }else if (indexPath.row == 3){
            _address = [[NSString alloc] init];
            _address = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user.address"]];
            NSNumber *firstLevel = nil, *secondLevel = nil;
            if (_address && _address.length > 0) {
                NSArray *locationArray = [_address componentsSeparatedByString:@" "];
                if (locationArray.count == 2) {
                    firstLevel = [AddressManager indexOfFirst:[locationArray firstObject]];
                    secondLevel = [AddressManager indexOfSecond:[locationArray lastObject] inFirst:[locationArray firstObject]];
                }
            }
            if (!firstLevel) {
                firstLevel = [NSNumber numberWithInteger:0];
            }
            if (!secondLevel) {
                secondLevel = [NSNumber numberWithInteger:0];
            }
            
            [ActionSheetStringPicker showPickerWithTitle:nil rows:@[[AddressManager firstLevelArray], [AddressManager secondLevelMap]] initialSelection:@[firstLevel, secondLevel] doneBlock:^(ActionSheetStringPicker *picker, NSArray * selectedIndex, NSArray *selectedValue) {
//                NSString *preValue = weakSelf.curUser.location;
//                NSString *location = [selectedValue componentsJoinedByString:@" "];
//                weakSelf.curUser.location = location;
//                [weakSelf.myTableView reloadData];
//                [[Coding_NetAPIManager sharedManager] request_UpdateUserInfo_WithObj:weakSelf.curUser andBlock:^(id data, NSError *error) {
//                    if (data) {
//                        weakSelf.curUser = data;
//                    }else{
//                        weakSelf.curUser.location = preValue;
//                    }
//                    [weakSelf.myTableView reloadData];
//                }];
            } cancelBlock:nil origin:self.view];
        }
    }
}

@end

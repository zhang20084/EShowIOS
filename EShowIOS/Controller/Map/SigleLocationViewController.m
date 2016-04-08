//
//  SigleLocationViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/3.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "SigleLocationViewController.h"
#import "TPKeyboardAVoidingTableView.h"
#import "MapViewController.h"

@interface SigleLocationViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic, strong) UITextField *addressInDetail_textField;

@end

@implementation SigleLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地图";
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] init];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 /255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0, ScreenWidth/5, 44.0f)];
            label.text = @"详细地址:";
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textAlignment = NSTextAlignmentNatural;
            label.textColor = [UIColor grayColor];
            [cell.contentView addSubview:label];

            UILabel *add_label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/5+20.0f, 0, ScreenWidth*4/5 - 50, 44.0f)];
            add_label.text = @"请输入地址";
            add_label.font = [UIFont systemFontOfSize:14.0f];
            add_label.textAlignment = NSTextAlignmentLeft;
            add_label.textColor = [UIColor colorWithRed:(200/255) green:(200/255) blue:(206/255) alpha:0.2f];
            [cell.contentView addSubview:add_label];
            
            UIImageView *image= [[UIImageView alloc] init];
            image.frame = CGRectMake(ScreenWidth - 44, 12, 20, 20);
            image.image = [UIImage imageNamed:@"address"];
            [cell.contentView addSubview:image];
            
            
        }else{
            
            _addressInDetail_textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/5 + 20.0f, 0, ScreenWidth*4/5, 44.0f)];
            _addressInDetail_textField.keyboardType = UIKeyboardTypeNumberPad;
            _addressInDetail_textField.font = [UIFont systemFontOfSize:14.0f];
            _addressInDetail_textField.placeholder = @"请完善详细地址";
            _addressInDetail_textField.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_addressInDetail_textField];
            
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        MapViewController *map_vc = [[MapViewController alloc] init];
        [self.navigationController pushViewController:map_vc animated:YES];
    }
}

@end

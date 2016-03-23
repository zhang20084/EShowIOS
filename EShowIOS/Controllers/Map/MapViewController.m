//
//  MapViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/21.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "MapViewController.h"
#import "TPKeyboardAVoidingTableView.h"
#import "SingleLocationViewController.h"

@interface MapViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic, strong) UIButton *address_button;
@property (nonatomic, strong) UITextField *addressInDetail_textField;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地图";
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] init];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 /255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
//            button.frame = CGRectMake(ScreenWidth-60, 7, 30, 30);
//            [cell.contentView addSubview:button];
            
            _address_button = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(ScreenWidth/5+20.0f, 0, ScreenWidth*4/5, 44.0f);
                [button setTitle:@"请输入地址" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                button;
            });
            
            [cell.contentView addSubview:_address_button];
            
        }else{
        
            _addressInDetail_textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/5 + 20.0f, 0, ScreenWidth*4/5, 44.0f)];
            _addressInDetail_textField.keyboardType = UIKeyboardTypeNumberPad;
            _addressInDetail_textField.font = [UIFont systemFontOfSize:14.0f];
            _addressInDetail_textField.placeholder = @"请完善详细地址";
            _addressInDetail_textField.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_addressInDetail_textField];
            
        }
    }
    
//    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kLoginPaddingLeftWidth];
    return cell;
}

- (void)goToMap
{
    SingleLocationViewController *singel_vc = [[SingleLocationViewController alloc] init];
    [self.navigationController pushViewController:singel_vc animated:YES];
}
@end

//
//  ForgetTelephoneViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/21.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "ForgetTelephoneViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "AFNetworking.h"
#import "ForgetPasswordViewController.h"

@interface ForgetTelephoneViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic, strong) UITextField *telephone_textfield;
@property (nonatomic, strong) UIButton *footerBtn;

@end

@implementation ForgetTelephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"找回密码";
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 /255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        _telephone_textfield = ({
            UITextField *telephone = [[UITextField alloc] init];
            telephone.frame = CGRectMake(20.0f, 0, ScreenWidth-30.0f, 55.0f);
            telephone.keyboardType = UIKeyboardTypeNumberPad;
            
            if (self.telephoneStr == nil) {
               
                telephone.placeholder = @"请输入手机号码";
            
            }else{
             
                telephone.text = [NSString stringWithFormat:@"%@",self.telephoneStr];
            
            }
            telephone.clearButtonMode = UITextFieldViewModeAlways;
            telephone;
        });
        
        [cell.contentView addSubview:_telephone_textfield];
    }
    
    return cell;
}

#pragma mark - Table view Header Footer
- (UIView *)customHeaderView{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.04*ScreenHeight)];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (UIView *)customFooterView{
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 150)];
    _footerBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"获取验证码" andFrame:CGRectMake(kLoginPaddingLeftWidth, 20, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendRegister)];
    [footerV addSubview:_footerBtn];
    
    return footerV;
}

- (void)sendRegister
{
    [self.telephone_textfield resignFirstResponder];
    
    if ([self.telephone_textfield.text length] !=11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:[NSString stringWithFormat:@"http://api.eshow.org.cn/user/check.json?"]
      parameters:@{
                   @"user.username":self.telephone_textfield.text,
                   @"type" : @"identity",
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *dic = responseObject;
             
             NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
             
             NSLog(@"显示数据:%@",str);
             
             if (dic[@"status"] == nil) {
                 return;
             }else if ([dic[@"status"] intValue] == 1){
                 
                 NSString *telephone = self.telephone_textfield.text;
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults setObject:telephone forKey:@"forget.telephone"];
                 
                 ForgetPasswordViewController *forgetPassword_vc = [[ForgetPasswordViewController alloc] init];
                 [self.navigationController pushViewController:forgetPassword_vc animated:YES];
                 
             }else{
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide: YES afterDelay: 2];
                 return;
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"error: %@", error);
             
         }];

}
@end

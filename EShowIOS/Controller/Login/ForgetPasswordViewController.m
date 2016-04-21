//
//  ForgetPasswordViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/18.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "TPKeyboardAVoidingTableView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface ForgetPasswordViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic, strong) UITextField *captcha_password;
@property (nonatomic, strong) UITextField *newpassword;
@property (nonatomic, strong) UITextField *newpassword_again;
@property (nonatomic, strong) UIButton *captcha_btn;
@property (nonatomic, strong) UIButton *submit_btn;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置密码";
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 /255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    
    }else{
    
        return 2;
    
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
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
            _captcha_password = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-137, 55.0)];
            _captcha_password.keyboardType = UIKeyboardTypeNumberPad;
            _captcha_password.placeholder = @"请输入验证码";
            _captcha_password.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_captcha_password];
            
            _captcha_btn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"语音播报" andFrame:CGRectMake(ScreenWidth-117, 7.5, 101, 40) target:self action:@selector(voicePrompt)];
            [cell.contentView addSubview:_captcha_btn];
            
        }
    }else{
        
        if (indexPath.row == 0) {
            _newpassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 55.0)];
            _newpassword.keyboardType = UIKeyboardTypeNumberPad;
            _newpassword.placeholder = @"请输入新密码";
            _newpassword.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_newpassword];
        }else{
            _newpassword_again = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth - 20, 55.0)];
            _newpassword_again.keyboardType = UIKeyboardTypeNumberPad;
            _newpassword_again.placeholder = @"请再次输入新密码";
            _newpassword_again.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_newpassword_again];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

-(void)viewDidLayoutSubviews
{
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view Header Footer
- (UIView *)customHeaderView{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.06*ScreenHeight)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, headerV.frame.origin.y, ScreenWidth, 0.06*ScreenHeight)];
    textLabel.text = @"已将验证码发送到手机号码";
    textLabel.textColor = [UIColor grayColor];
    textLabel.font = [UIFont systemFontOfSize:14.0];
    [headerV addSubview:textLabel];
    
    return headerV;
}

- (UIView *)customFooterView{
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 150)];
    
    UILabel *prompt_text = [[UILabel alloc] initWithFrame:CGRectMake(20, -20.0, ScreenWidth, 40)];
    prompt_text.text = @"密码长度为6-20位,字母或数字";
    prompt_text.textColor = [UIColor grayColor];
    prompt_text.font = [UIFont systemFontOfSize:14.0];
    [footerV addSubview:prompt_text];
    
    _submit_btn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"提交" andFrame:CGRectMake(kLoginPaddingLeftWidth, 20, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendRegister)];
    [footerV addSubview:_submit_btn];
    
    return footerV;
}

- (void)voicePrompt
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_captcha_btn setTitle:@"语音播报" forState:UIControlStateNormal];
                _captcha_btn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_captcha_btn setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _captcha_btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:[NSString stringWithFormat:@"http://api.eshow.org.cn/code/voice.json?"]
      parameters:@{
                   @"mobile" : [[NSUserDefaults standardUserDefaults] objectForKey:@"forget.telephone"],
                   @"type":@"change",
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *dic = responseObject;
             
             NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
             
             NSLog(@"success = %@",str);
             
             if (dic[@"status"] == nil) {
                 return;
             }else if ([dic[@"status"] intValue] == 0)
             {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide: YES afterDelay: 2];
                 return;
                 
             }else if ([dic[@"status"]intValue] == 1){
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide: YES afterDelay: 2];
                 
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

- (void)sendRegister
{

    if (_newpassword_again.text || _newpassword.text) {
        
    }else{
        
        return;
    
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:[NSString stringWithFormat:@"http://api.eshow.org.cn/user/password.json?"]
      parameters:@{
                   @"code" : _captcha_password.text,
                   @"user.password" : _newpassword.text,
                   @"user.username" : [[NSUserDefaults standardUserDefaults] objectForKey:@"forget.telephone"],
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *dic = responseObject;
             
             NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
             
             NSLog(@"success = %@",str);
             
             if (dic[@"status"] == nil) {
                 return;
             }else if ([dic[@"status"] intValue] == 0)
             {
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide: YES afterDelay: 2];
                 return;
                 
             }else if ([dic[@"status"]intValue] == 1){
                 
                 MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                 hud.mode = MBProgressHUDModeText;
                 hud.labelText = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                 hud.removeFromSuperViewOnHide = YES;
                 [hud hide: YES afterDelay: 2];
                 
                 [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
                 
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RegisterCaptchaViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/8.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RegisterCaptchaViewController.h"
#import "AppDelegate.h"
#import "TPKeyboardAVoidingTableView.h"
#import "AFNetworking.h"

@interface RegisterCaptchaViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)TPKeyboardAvoidingTableView *myTableView;
@property (nonatomic ,strong)UITextField *captcha_textField;
@property (nonatomic ,strong)UITextField *paaaword_textField;
@property (nonatomic, strong)UIButton *captchaBtn;
@property (nonatomic, strong)UIButton *footerBtn;

@end

@implementation RegisterCaptchaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
            _captcha_textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-137, 55.0)];
            _captcha_textField.keyboardType = UIKeyboardTypeNumberPad;
            _captcha_textField.placeholder = @"请输入验证码";
            _captcha_textField.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_captcha_textField];

            _captchaBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"语音播报" andFrame:CGRectMake(ScreenWidth-117, 7.5, 101, 40) target:self action:@selector(voicePrompt)];
            [cell.contentView addSubview:_captchaBtn];

        }
    }else{
    
        if (indexPath.row == 0) {
            _paaaword_textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 55.0)];
            _paaaword_textField.keyboardType = UIKeyboardTypeNumberPad;
            _paaaword_textField.placeholder = @"请输入新密码";
            _paaaword_textField.clearButtonMode = UITextFieldViewModeAlways;
            [cell.contentView addSubview:_paaaword_textField];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
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
    
    _footerBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"提交" andFrame:CGRectMake(kLoginPaddingLeftWidth, 20, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendRegister)];
    [footerV addSubview:_footerBtn];
    
    return footerV;
}

- (void)sendRegister
{
    [self.captcha_textField resignFirstResponder];
    [self.paaaword_textField resignFirstResponder];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *registerUserNam = [userDefault objectForKey:@"user.username"];
    
    [manager POST:[NSString stringWithFormat:@"http://api.eshow.org.cn/user/signup.json?"]
      parameters:@{
                   @"user.password" : self.paaaword_textField.text,
                   @"code": self.captcha_textField.text,
                   @"user.username": registerUserNam,
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"error: %@", error);
             
         }];
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
                [_captchaBtn setTitle:@"语音播报" forState:UIControlStateNormal];
                _captchaBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_captchaBtn setTitle:[NSString stringWithFormat:@"%@秒重发",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _captchaBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:[NSString stringWithFormat:@"http://api.eshow.org.cn/code/voice.json?"]
      parameters:@{
                   @"mobile" : [[NSUserDefaults standardUserDefaults] objectForKey:@"remember.telephone"],
                   @"type":@"register",
                   }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *dic = responseObject;
             
             NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
             
             NSLog(@"success = %@",str);
             
             if (dic[@"status"] == nil) {
                 return;
             }else if ([dic[@"status"] intValue] == 0)
             {
                 [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                 return;
                 
             }else if ([dic[@"status"]intValue] == 1){
             
                 [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                 
             }else{
             
                 [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                 return;
             }
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"error: %@", error);
             
         }];
}
@end

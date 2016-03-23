//
//  LoginViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/1.
//  Copyright © 2016年 JinJing. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetTelephoneViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UITTTAttributedLabel.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

#import "UMSocial.h"
#import "WXApi.h"

@interface LoginViewController () <UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,UITextFieldDelegate>
{
    UITextField * username;
    UITextField * password;
}

@property (strong, nonatomic) UIView *bottomView;//第三方登录所在view
@property (strong, nonatomic) TPKeyboardAvoidingTableView *myTableView;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UITextField *telephone_text;
@property (strong, nonatomic) UITextField *password_text;
@property (strong, nonatomic) UIButton *QQ_button;
@property (strong, nonatomic) UIButton *Wechat_button;
@property (strong, nonatomic) UIImageView *rightImage, *leftImage;
@property (strong, nonatomic) UILabel *otherLoginWay;

@property (strong, nonatomic) NSString *msg, *status;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(ClickedRegisterButton:)]];
    
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

        tableView.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 /255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    self.myTableView.tableHeaderView = [self customHeaderView];
    self.myTableView.tableFooterView=[self customFooterView];
    
    [self configBottomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)ClickedRegisterButton:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - tableViewCell
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        _telephone_text = [[UITextField alloc] init];
        _telephone_text.frame = CGRectMake(20, 0, ScreenWidth - 20, 55.0);
        _telephone_text.keyboardType = UIKeyboardTypePhonePad;
        _telephone_text.placeholder = @"请输入手机号码";
        _telephone_text.delegate = self;
        _telephone_text.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_telephone_text];
        
    }else {
    
        _password_text = [[UITextField alloc] init];
        _password_text.frame = CGRectMake(20, 0, ScreenWidth - 20, 55.0);
        _password_text.keyboardType = UIKeyboardTypePhonePad;
        _password_text.placeholder = @"请输入密码";
        _password_text.delegate = self;
        _password_text.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:_password_text];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view Header Footer
- (UIView *)customHeaderView{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.04*ScreenHeight)];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (UIView *)customFooterView{
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 150)];
    _loginBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"登录" andFrame:CGRectMake(kLoginPaddingLeftWidth, 0.04*ScreenHeight, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendLogin)];
    [footerV addSubview:_loginBtn];
    
    UIButton *cannotLoginBtn = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [button setTitleColor:[UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1] forState:UIControlStateHighlighted];
        
        [button setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [footerV addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.right.equalTo (footerV).with.offset(-kLoginPaddingLeftWidth);
            make.top.equalTo(_loginBtn.mas_bottom).offset(20);
        }];
        button;
    });
    
    [cannotLoginBtn addTarget:self action:@selector(cannotLoginBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return footerV;
}

#pragma mark BottomView
- (void)configBottomView
{
    CGFloat buttonWidth = ScreenWidth * 0.3;
    CGFloat buttonHeight = kScaleFrom_iPhone5_Desgin(40);
    CGFloat paddingToCenter = kScaleFrom_iPhone5_Desgin(20);
    CGFloat paddingToBottom = kScaleFrom_iPhone5_Desgin(20);
    
    self.Wechat_button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(WechatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"wx_login_open"] forState:UIControlStateNormal];
        button;
    });
    self.QQ_button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(QQBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"qq_login_open"] forState:UIControlStateNormal];
        button;
    });
    
    [self.view addSubview:self.Wechat_button];
    [self.view addSubview:self.QQ_button];
    
    [self.Wechat_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        make.right.equalTo(self.view.mas_centerX).offset(-paddingToCenter);
        make.bottom.equalTo(self.view).offset(-paddingToBottom);
    }];
    [self.QQ_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        make.left.equalTo(self.view.mas_centerX).offset(paddingToCenter);
        make.bottom.equalTo(self.view).offset(-paddingToBottom);
    }];
    
    //label
    self.otherLoginWay = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"或用其它方式快速登录";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    [self.view addSubview:self.otherLoginWay];
    
    CGFloat labelWidth = ScreenWidth/2;
    CGFloat labelHeight = kScaleFrom_iPhone5_Desgin(20);
    CGFloat labelToCenter = ScreenWidth/4;
    CGFloat labelToBottom = kScaleFrom_iPhone5_Desgin(80);
    
    [self.otherLoginWay mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(labelWidth, labelHeight));
        make.right.equalTo (self.view.mas_centerX).offset(labelToCenter);
        make.bottom.equalTo(self.view).offset(-labelToBottom);
    }];
    
    //imageview
    self.rightImage = ({
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor grayColor];
        image;
    });
    
    self.leftImage = ({
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor grayColor];
        image;
    });
    
    [self.view addSubview:self.rightImage];
    [self.view addSubview:self.leftImage];
    
    CGFloat imageWith = ScreenWidth/4;
    CGFloat imageHeight = 0.5f;
    CGFloat imageToCenter = kScaleFrom_iPhone5_Desgin(15);
    CGFloat imageToBottom = kScaleFrom_iPhone5_Desgin(90);
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(imageWith, imageHeight));
        make.right.equalTo (self.view).with.offset(-imageToCenter);
        make.bottom.equalTo(self.view).offset(-imageToBottom);
    }];
    
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo (CGSizeMake(imageWith, imageHeight));
        make.left.equalTo (self.view).with.offset(imageToCenter);
        make.bottom.equalTo(self.view).offset(-imageToBottom);
    }];
    
}

- (void)cannotLoginBtnClicked:(id)sender {

    ForgetTelephoneViewController *forget_vc = [[ForgetTelephoneViewController alloc] init];
    [self.navigationController pushViewController:forget_vc animated:YES];
    
}

#pragma mark Btn Clicked
- (void)sendLogin
{
    [self.telephone_text resignFirstResponder];
    [self.password_text resignFirstResponder];
    
    if ([self.telephone_text.text length] !=11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([self.password_text.text length] <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSString *userName = self.telephone_text.text;
    NSString *passwordNum = self.password_text.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager POST:[NSString stringWithFormat:@"%@user/login.json?",BaseUrl]
             parameters:@{
                          
                          @"user.password" : self.password_text.text,
                          @"user.username" : self.telephone_text.text,
                          
                          } success:^(AFHTTPRequestOperation *operation,id responseObject) {
                              
                              NSDictionary *dic = responseObject;
                              
                              NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
                              
                              NSLog(@"显示数据:%@",str);
                              
                              if (dic[@"status"] == nil) {
                                  return;
                              }else if ([dic[@"status"] intValue] == 0){
                                  
                                  [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                  return;
                                  
                              }else if ([dic[@"status"] intValue] == 1){
                              
                                  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                  [userDefaults setObject:userName forKey:@"user.username"];
                                  [userDefaults setObject:passwordNum forKey:@"user.password"];
                                  [userDefaults synchronize];
                                  [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
                                  
                                  [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                  
                              }else if ([dic[@"status"] intValue] == -5){
                              
                                  [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                  return;
                                  
                              }
                              
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              NSLog(@"error: %@", error);
                              
                          }];
    

}

#pragma mark WeiXin

- (void)WechatBtnClicked
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            //调用接口
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            
            [manager POST:[NSString stringWithFormat:@"http://api.eshow.org.cn/user/third.json?"]
               parameters:@{
                            
                            @"thirdParty.platform" : @"weixin",
                            @"thirdParty.nickname" : snsAccount.userName,
                            @"thirdParty.username.url" : snsAccount.iconURL,
                            @"thirdParty.username" : snsAccount.accessToken,
                            
                            } success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                
                                NSDictionary *dic = responseObject;
                                
                                NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
                                
                                NSLog(@"显示数据:%@",str);
                                
                                if (dic[@"status"] == nil) {
                                    return;
                                }else if ([dic[@"status"] intValue] == 0){
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    return;
                                    
                                }else if ([dic[@"status"] intValue] == 1){
                                    
                                    [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    
                                }else if ([dic[@"status"] intValue] == -5){
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    return;
                                    
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                                NSLog(@"error: %@", error);
                                
                            }];

        }

    });
}

#pragma mark QQ

- (void)QQBtnClicked
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            
            //调用接口
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
            
            [manager POST:[NSString stringWithFormat:@"http://api.eshow.org.cn/user/third.json?"]
               parameters:@{
                            
                            @"thirdParty.platform" : @"qq",
                            @"thirdParty.nickname" : snsAccount.userName,
                            @"thirdParty.username.url" : snsAccount.iconURL,
                            @"thirdParty.username" : snsAccount.accessToken,
                            
                            } success:^(AFHTTPRequestOperation *operation,id responseObject) {
                                
                                NSDictionary *dic = responseObject;
                                
                                NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
                                
                                NSLog(@"显示数据:%@",str);
                                
                                if (dic[@"status"] == nil) {
                                    return;
                                }else if ([dic[@"status"] intValue] == 0){
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    return;
                                    
                                }else if ([dic[@"status"] intValue] == 1){
                                    
                                    [((AppDelegate *)[UIApplication sharedApplication].delegate) setupTabViewController];
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    
                                }else if ([dic[@"status"] intValue] == -5){
                                    
                                    [self.view makeToast:dic[@"msg"] duration:2 position:@"center"];
                                    return;
                                    
                                }
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                                NSLog(@"error: %@", error);
                                
                            }];
            
        }});
}

@end

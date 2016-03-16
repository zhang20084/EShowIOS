//
//  RegisterViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/1.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterCaptchaViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "Input_OnlyText_Cell.h"//文本
#import "UITTTAttributedLabel.h"
#import "AppDelegate.h"
#import "Login.h"
#import "EShow_NetAPIManager.h"

@interface RegisterViewController ()<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate>

@property (strong, nonatomic) UIButton *footerBtn;
@property (strong, nonatomic) TPKeyboardAvoidingTableView *myTableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UITextField *username_textField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    // Do any additional setup after loading the view.
    
    //    添加myTableView
    _myTableView = ({
        TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [tableView registerNib:[UINib nibWithNibName:kCellIdentifier_Input_OnlyText_Cell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell];
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
    
    if (self.navigationController.childViewControllers.count <= 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dismissSelf{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        self.username_textField = [[UITextField alloc] init];
        self.username_textField.frame = CGRectMake(20, 0, ScreenWidth-20, 55.0);
        self.username_textField.keyboardType = UIKeyboardTypeNumberPad;
        self.username_textField.placeholder = @"请输入手机号码";
        self.username_textField.clearButtonMode = UITextFieldViewModeAlways;
        [cell.contentView addSubview:self.username_textField];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

#pragma mark - Table view Header Footer
- (UIView *)customHeaderView{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.04*ScreenHeight)];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

- (UIView *)customFooterView{
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 150)];
    _footerBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"提交" andFrame:CGRectMake(kLoginPaddingLeftWidth, 20, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendRegister)];
    [footerV addSubview:_footerBtn];
    
    UITTTAttributedLabel *lineLabel = ({
        UITTTAttributedLabel *label = [UITTTAttributedLabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        label.linkAttributes = kLinkAttributes;
        label.activeLinkAttributes = kLinkAttributesActive;
        label.delegate = self;
        label;
    });
    NSString * tipStr = @"我已阅读并同意《EShow 使用协议》";
    lineLabel.text = tipStr;
    [lineLabel addLinkToTransitInformation:@{@"actionStr": @"gotoServiceTermsVC"} withRange:[tipStr rangeOfString:@"《EShow 使用协议》"]];
    CGRect footerBtnFrame = _footerBtn.frame;
    lineLabel.frame = CGRectMake(CGRectGetMinX(footerBtnFrame), CGRectGetMaxY(footerBtnFrame) +12, CGRectGetWidth(footerBtnFrame), 12);
    [footerV addSubview:lineLabel];
    
    return footerV;
}

#pragma mark Btn Clicked
- (void)sendRegister
{
    [self.username_textField resignFirstResponder];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/user/check.json?type=register&user.username=%@",self.username_textField.text];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 隐藏系统风火轮
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //json解析
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"---获取到的json格式的字典--%@",resultDic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 解析失败隐藏系统风火轮(可以打印error.userInfo查看错误信息)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    
    RegisterCaptchaViewController *captchaVC = [[RegisterCaptchaViewController alloc] init];
    [self.navigationController pushViewController:captchaVC animated:YES];
}

#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    [self gotoServiceTermsVC];
}

#pragma mark VC
- (void)gotoServiceTermsVC{
//    NSString *pathForServiceterms = [[NSBundle mainBundle] pathForResource:@"service_terms" ofType:@"html"];
//    WebViewController *vc = [WebViewController webVCWithUrlStr:pathForServiceterms];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end

//
//  RegisterCaptchaViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/8.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "RegisterCaptchaViewController.h"
#import "TPKeyboardAVoidingTableView.h"

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

            _captchaBtn = [UIButton buttonWithStyle:StrapInfoStyle andTitle:@"语音播报" andFrame:CGRectMake(ScreenWidth-117, 7.5, 101, 40) target:self action:@selector(voicePrompt)];
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

//    RAC(self, footerBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, username_textField.text)] reduce:^id(NSNumber *username){
//        if ((username && username.boolValue) <= 0 ) {
//            return @(NO);
//        }else{
//            return @(YES);
//        }
//    }];
    
    return footerV;
}

- (void)sendRegister
{

}

- (void)voicePrompt
{

}
@end

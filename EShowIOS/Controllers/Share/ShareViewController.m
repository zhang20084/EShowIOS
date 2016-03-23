//
//  ShareViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "ShareViewController.h"
#import "UMSocial.h"

@interface ShareViewController () <UMSocialUIDelegate>

@property (nonatomic, strong)UIButton *shareBtn;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分享";
    self.view.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0f) green:(247.0 / 255.0f) blue:(240.0 / 255.0f) alpha:1.0f];
    
    __weak typeof (self) weakSelf = self;
    
    UIView *bgView = [[UIView alloc] init];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo (weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 45));
    }];
    
    _shareBtn = [UIButton buttonWithStyle:StrapSuccessStyle andTitle:@"分享" andFrame:CGRectMake(kLoginPaddingLeftWidth, 0, ScreenWidth-kLoginPaddingLeftWidth*2, 45) target:self action:@selector(sendShare)];
    [bgView addSubview:_shareBtn];
}

- (void)sendShare
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56ceca68e0f55a2ece000d68" shareText:@"你要分享的文字" shareImage:[UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,nil] delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

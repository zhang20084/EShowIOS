//
//  ShareViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "ShareViewController.h"
#import "UIImageView+WebCache.h"
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
    
    UIView *footView = [UIView new];
    footView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2);
    [self.view addSubview:footView];
    
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:@"http://qr.topscan.com/api.php?text="]];
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(footView);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth/3, ScreenWidth/3));
    }];
    
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
    NSString *shareText = @"友盟社会化组件可以让移动应用快速具备社会化分享、登录、评论、喜欢等功能，并提供实时、全面的社会化数据统计分析服务。 http://www.umeng.com/social";             //分享内嵌文字
    //    UIImage *shareImage = [UIImage imageNamed:@"UMS_social_demo"];          //分享内嵌图片
    UIImage *shareImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UMS_social_demo" ofType:@"png"]];
    
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56ceca68e0f55a2ece000d68"
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                       delegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

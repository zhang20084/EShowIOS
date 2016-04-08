//
//  YWPingPayWebViewController.h
//  EShowIOS
//
//  Created by 金璟 on 16/4/5.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
@interface PingPayWebViewController : UIViewController<UIAlertViewDelegate,UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    UIAlertView* mAlert;
    NSMutableData* mData;
}

@property (nonatomic,retain)UIWebView *webView;
@property (nonatomic,strong)NSString *urlString;
@property (nonatomic,strong)NSString *titleText;
@property (nonatomic,strong)NSString *orderType;
@property (nonatomic,strong)NSString *sendStyle;

@property (nonatomic, copy) NSString *disPrice;
@property (nonatomic, copy) NSString *shareUrl;

@property(nonatomic, retain)NSString *channel;
@property(nonatomic, retain)NSString *urlFormJs;


- (void)payWithChannel:(NSString *)ch amount:(NSString *)amount;
- (void)showAlertWait;
- (void)showAlertMessage:(NSString*)msg;
- (void)hideAlert;


@end

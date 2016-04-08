//
//  WebViewController.h
//  EShowIOS
//
//  Created by 金璟 on 16/4/7.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

@interface WebViewController : UIViewController <NJKWebViewProgressDelegate>

@property (nonatomic,retain)UIWebView *webView;
@property (nonatomic,strong)NSString *urlString;
@property (nonatomic,strong)NSString *titleText;

@end

//
//  AllMapViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/6.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "AllMapViewController.h"
#import "AFNetworking.h"
#import <MBProgressHUD.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface AllMapViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation AllMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(self.view);
        }];
        tableView;
    });
    
    [self UpDateForMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)UpDateForMap
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://restapi.amap.com/v3/place/text?"];
    
    [manager POST:urlStr
       parameters:@{
                    @"keywords" : @"电影院",
                    @"city" : @"beijing",
                    @"offset" : @"100",
                    @"page" : @"1",
                    @"key" : @"b9410630740ff6a90c303b4bfdfef1ef",
                    @"extensions" : @"all",
                    } success:^(AFHTTPRequestOperation *operation,id responseObject) {
           
           NSDictionary *dic = responseObject;
           
           NSString *str = [NSString stringWithFormat:@"msg:%@;status:%@",dic[@"msg"],dic[@"status"]];
           
           NSLog(@"显示数据:%@",str);
           
           if ([dic[@"status"]intValue] == 1) {
               
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.labelText = @"正在加载";
               hud.removeFromSuperViewOnHide = YES;
               [hud hide: YES afterDelay: 2];
               
               NSArray *arr = dic[@"pois"];
               
               for (int i = 0; i<arr.count; i++) {
                   AMapPOI *tip = [[AMapPOI alloc] init];
                   
                   if (![arr[i][@"name"] isKindOfClass:[NSNull class]]) {
                       tip.name=arr[i][@"name"];
                   } else {
                       tip.name = @"";
                   }
               }
               
           }else{
               
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.labelText = @"网络出错了";
               hud.removeFromSuperViewOnHide = YES;
               [hud hide: YES afterDelay: 2];
               return ;
               
           }
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
           NSLog(@"error: %@", error);
           
       }];
    
}

#pragma mark tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"firstTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"address"];
    }
    
    AMapPOI *tip = [[AMapPOI alloc] init];
    
    cell.textLabel.text = tip.name;
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

@end

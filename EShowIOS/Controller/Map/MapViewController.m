//
//  CenterViewController.m
//  瑶瑶切克闹
//
//  Created by 金璟 on 16/4/14.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AMapTipAnnotation.h"
#import "POIAnnotation.h"

#import "LFLUISegmentedControl.h"
#import "AFNetworking.h"
@interface MapViewController () <MAMapViewDelegate, AMapSearchDelegate,UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,LFLUISegmentedControlDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;
@property (nonatomic, strong) NSMutableArray *tips;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) LFLUISegmentedControl * LFLuisement;
@property (nonatomic, strong) UITableView *AllMap_vc;
@property (nonatomic, strong) UITableView *office_vc;
@property (nonatomic, strong) UITableView *house_vc;
@property (nonatomic, strong) UITableView *school_vc;

@property (nonatomic, strong) NSMutableArray *AllMap_arr;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize search  = _search;

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
        self.AllMap_arr = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地图";
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2 + 64)];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;//打开定位
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow];//显示模式，不跟随用户位置
    
    [self.view addSubview:self.mapView];
    
    //搜索
    [self initSearchBar];
    [self initSearchDisplay];
    
    /*分页*/
    LFLUISegmentedControl* LFLuisement=[[LFLUISegmentedControl alloc]initWithFrame:CGRectMake(0, ScreenHeight/2, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    LFLuisement.delegate = self;
    NSArray* LFLarray=[NSArray arrayWithObjects:@"全部",@"写字楼",@"小区",@"学校",nil];
    [LFLuisement AddSegumentArray:LFLarray];
    [LFLuisement selectTheSegument:0];
    self.LFLuisement = LFLuisement;
    [self.view addSubview:LFLuisement];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createMainScrollView];
    
    [self UpDateForMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定位回调 获取当前坐标
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    
    [_mapView setZoomLevel:16.1 animated:YES];
}

#pragma mark search
#pragma mark - Initialization
- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"搜索";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
    self.displayController.searchContentsController.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    /* 按下键盘enter, 搜索poi */
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords         = key;
    request.city             = @"010";
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"f912d3064492b7d1102a9bc6de5b77c1";
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //发起输入提示搜索
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    [self.displayController.searchResultsTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _AllMap_vc) {
        return self.AllMap_arr.count;
    }else if (tableView == _office_vc){
        return 30;
    }else if (tableView == _house_vc){
        return 30;
    }else if (tableView == _school_vc){
        return 30;
    }else{
        return self.tips.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _AllMap_vc) {
        static NSString *cellIdentifier = @"firstTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
            cell.imageView.image = [UIImage imageNamed:@"address"];
        }
        
        AMapPOI *poi = self.AllMap_arr[indexPath.row];
        
        cell.textLabel.text = poi.name;
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }else if (tableView == _office_vc){
        static NSString *cellIdentifier = @"secondTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
            cell.imageView.image = [UIImage imageNamed:@"address"];
        }
        
        cell.textLabel.text = @"我擦";
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }else if (tableView == _house_vc){
        static NSString *cellIdentifier = @"ThirdTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
            cell.imageView.image = [UIImage imageNamed:@"address"];
        }
        
        cell.textLabel.text = @"我擦";
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }else if (tableView == _school_vc){
        static NSString *cellIdentifier = @"fourTableViewCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier];
            cell.imageView.image = [UIImage imageNamed:@"address"];
        }
        
        cell.textLabel.text = @"我擦";
        cell.textLabel.textColor = [UIColor blackColor];
        
        return cell;
    }else{
        static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:tipCellIdentifier];
            cell.imageView.image = [UIImage imageNamed:@"address"];
        }
    
        AMapTip *tip = self.tips[indexPath.row];
    
        if (tip.location == nil)
        {
            cell.imageView.image = [UIImage imageNamed:@"search"];
        }
    
        cell.textLabel.text = tip.name;
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.text = tip.district;
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        
        return cell;
    }
}

-(void)viewDidLayoutSubviews
{
    if ([_AllMap_vc respondsToSelector:@selector(setSeparatorInset:)]) {
        [_AllMap_vc setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_AllMap_vc respondsToSelector:@selector(setLayoutMargins:)]) {
        [_AllMap_vc setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndShowAnnotationWithTip:tip];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

/* 清除annotations & overlays */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (void)clearAndShowAnnotationWithTip:(AMapTip *)tip
{
    /* 清除annotations & overlays */
    [self clear];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
        AMapTipAnnotation *annotation = [[AMapTipAnnotation alloc] initWithMapTip:tip];
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate];
        [self.mapView selectAnnotation:annotation animated:YES];
    }
    else if (tip.uid != nil && tip.location == nil)/* 公交路线，显示出来*/
    {
        AMapBusLineIDSearchRequest *request = [[AMapBusLineIDSearchRequest alloc] init];
        request.city                        = @"北京";
        request.uid                         = tip.uid;
        request.requireExtension            = YES;
        
        [self.search AMapBusLineIDSearch:request];
    }
    else if(tip.uid == nil && tip.location == nil)/* 品牌名，进行POI关键字搜索 */
    {
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.keywords         = tip.name;
        request.city             = @"010";
        request.requireExtension = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
}

#pragma mark segment
//创建正文ScrollView内容
- (void)createMainScrollView {
    self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight/2 + 44, ScreenWidth,ScreenHeight/2 - 44)];
    self.mainScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.bounces = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight/2-44);
    //设置代理
    self.mainScrollView.delegate = self;
    
    _AllMap_vc = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth * 0, 0, ScreenWidth,ScreenHeight)];
    _AllMap_vc.delegate = self;
    _AllMap_vc.dataSource = self;
    [self.mainScrollView addSubview:_AllMap_vc];
    
    _office_vc = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * 1, 0, ScreenWidth, ScreenHeight)];
    _office_vc.delegate = self;
    _office_vc.dataSource = self;
    [self.mainScrollView addSubview:_office_vc];
    
    _house_vc = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight)];
    _house_vc.delegate = self;
    _house_vc.dataSource = self;
    [self.mainScrollView addSubview:_house_vc];
    
    _school_vc = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth * 3, 0, ScreenWidth, ScreenHeight)];
    _school_vc.delegate = self;
    _school_vc.dataSource = self;
    [self.mainScrollView addSubview:_school_vc];

}

#pragma mark --- UIScrollView代理方法

static NSInteger pageNumber = 0;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNumber = (int)(scrollView.contentOffset.x / ScreenWidth + 0.5);
    //    滑动SV里视图,切换标题
    [self.LFLuisement selectTheSegument:pageNumber];
}

#pragma mark ---SegmentedControlDelegate
-(void)uisegumentSelectionChange:(NSInteger)selection{
    //加入动画,显得不太过于生硬切换
    [UIView animateWithDuration:.2 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(ScreenWidth *selection, 0)];
    }];
}

- (void)UpDateForMap
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:[NSString stringWithFormat:@"http://restapi.amap.com/v3/place/text?"]
       parameters:@{
                    @"key" : @"b9410630740ff6a90c303b4bfdfef1ef",
                    @"keywords":@"写字楼",
//                    @"types":@"高等院校",
                    @"city":@"无锡",
                    @"children":@"1",
                    @"offset":@"20",
                    @"page":@"1",
                    @"extensions" : @"all",
                    }
        success:^(AFHTTPRequestOperation *operation,id responseObject) {
           
           NSDictionary *dic = responseObject;
           
           NSString *str = [NSString stringWithFormat:@"status:%@",dic[@"status"]];
           
           NSLog(@"显示数据:%@",str);
           
           if ([dic[@"status"]intValue] == 1) {
               
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.labelText = @"正在加载";
               hud.removeFromSuperViewOnHide = YES;
               [hud hide: YES afterDelay: 2];
               
               _AllMap_arr = [[NSMutableArray alloc] initWithCapacity:0];
               NSArray *arr = dic[@"pois"];
               
               for (int i = 0; i<arr.count; i++) {
                   
                   AMapPOI *tip = [[AMapPOI alloc] init];
                   
                   if (![arr[i][@"name"] isKindOfClass:[NSNull class]]) {
                       tip.name=arr[i][@"name"];
                   } else {
                       tip.name = @"";
                   }
                   [_AllMap_arr addObject:tip];
               }
               [_AllMap_vc reloadData];
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

@end

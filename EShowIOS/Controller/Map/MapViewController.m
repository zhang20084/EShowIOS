//
//  MapViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/2.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>

//分页
#import "UIParameter.h"
#import "NinaPagerView.h"

@interface MapViewController () <MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [MAMapServices sharedServices].apiKey = @"49e47cbf981bd30f5f2d1aca34e2e80f";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;//开启定位开关
    
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];//地图跟着位置移动
    
    //后台持续定位
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    
//    //分页
//    NSArray *titleArray = @[@"全部",@"写字楼",@"小区",@"学校"];
//    NSArray *vcsArray = @[@"AllMapViewController",@"OfficeBuildingViewController",@"HouseViewController",@"SchoolViewController"];
//    NSArray *colorArray = @[[UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1],
//                            [UIColor grayColor],
//                            [UIColor colorWithRed:(247 / 255.0f) green:(105 / 255.0f) blue:(86 / 255.0f) alpha:1]];
//    NinaPagerView *ninaPagerView = [[NinaPagerView alloc] initWithTitles:titleArray WithVCs:vcsArray WithColorArrays:colorArray];
//    ninaPagerView.frame = CGRectMake(0, ScreenHeight/2, ScreenWidth, ScreenHeight);
//    [self.view addSubview:ninaPagerView];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

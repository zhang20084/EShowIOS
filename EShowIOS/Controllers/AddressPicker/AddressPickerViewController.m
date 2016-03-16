//
//  AddressPickerViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "AddressPickerViewController.h"
#import "JJAddressPickerController.h"

@interface AddressPickerViewController () <JJAddressPickerDataSource,JJAddressPickerDelegate>

@end

@implementation AddressPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >=7.0) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    JJAddressPickerController *addressPicker_VC = [[JJAddressPickerController alloc] initWithFrame:self.view.frame];
    addressPicker_VC.delegate = self;
    addressPicker_VC.dataSource = self;
    
    [self addChildViewController:addressPicker_VC];
    [self.view addSubview:addressPicker_VC.view];
}

#pragma mark - BAddressController Delegate
- (NSArray*)arrayOfHotCitiesInAddressPicker:(JJAddressPickerController *)addressPicker{
    return @[@"北京",@"上海",@"深圳",@"杭州",@"广州",@"武汉",@"天津",@"重庆",@"成都",@"苏州"];
}


- (void)addressPicker:(JJAddressPickerController *)addressPicker didSelectedCity:(NSString *)city{
    NSLog(@"%@",city);
}

- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

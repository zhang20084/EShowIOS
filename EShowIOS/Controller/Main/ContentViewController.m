//
//  ContentViewController.m
//  EShowIOS
//
//  Created by 金璟 on 16/4/1.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "ContentViewController.h"
#import "PopMenu.h"

#import "SigleLocationViewController.h"//地图
#import "PingPayWebViewController.h"//支付
#import "ShareViewController.h"//分享
#import "QRCScannerViewController.h"//扫一扫
#import "AddressPickerViewController.h"//城市选择
#import "BaseRDVTabViewController.h"//个人信息页面
#import "PersonalInformationViewController.h"

@interface ContentViewController () <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIImageView *imageLogo;
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) PopMenu *myPopMenu;
@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    [self setupNavBtn];
}

- (void) setupNavBtn
{
    UIBarButtonItem *plus_btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(addItemClicked:)];
    UIBarButtonItem *search_btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClicked:)];
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:plus_btn, search_btn, nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma make VC
- (void)addItemClicked:(id)sender
{
    NSArray *menuItems = @[[MenuItem itemWithTitle:@"扫一扫" iconName:@"saoyisao" index:0],
                           [MenuItem itemWithTitle:@"系统信息" iconName:@"xitongmessage" index:1],
                           [MenuItem itemWithTitle:@"透传信息" iconName:@"touchuanmessage" index:2],
                           ];
    
    if (!_myPopMenu){
        _myPopMenu = [[PopMenu alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) items:menuItems];
        _myPopMenu.perRowItemCount = 1;
        _myPopMenu.menuAnimationType = kPopMenuAnimationTypeSina;
    }
    
    @weakify(self);//@weakify 将当前对象声明为weak.. 这样block内部引用当前对象,就不会造成引用计数+1可以破解循环引用
    _myPopMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem){
        
        
        @strongify(self);//@strongify 相当于声明一个局部的strong对象,等于当前对象.可以保证block调用的时候,内部的对象不会释放
        switch (selectedItem.index) {
            case 0:
                [self goToNewAVFoundationVC];
                break;
                
            default:
                break;
        }
    };
    [_myPopMenu showMenuAtView:kKeyWindow startPoint:CGPointMake(0, -100) endPoint:CGPointMake(0, -100)];
}

- (void)goToNewAVFoundationVC
{
    QRCScannerViewController *scan_vc = [[QRCScannerViewController alloc] init];
    [self.navigationController pushViewController:scan_vc animated:YES];
}

#pragma mark Search
- (void)searchItemClicked:(id)sender{
//    if (!_mySearchBar) {
//        _mySearchBar = ({
//            UISearchBar *searchBar = [[UISearchBar alloc] init];
//            searchBar.delegate = self;
//            [searchBar sizeToFit];
//            [searchBar setPlaceholder:@"搜索"];
//            [searchBar setTintColor:[UIColor orangeColor]];
//            searchBar;
//        });
//        [self.navigationController.view addSubview:_mySearchBar];
//        [_mySearchBar setY:20];
//    }
//    if (!_mySearchDisplayController) {
//        _mySearchDisplayController = ({
//            UISearchDisplayController *searchVC = [[UISearchDisplayController alloc] initWithSearchBar:_mySearchBar contentsController:self];
//            searchVC.searchResultsTableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(_mySearchBar.frame), 0, CGRectGetHeight(self.rdv_tabBarController.tabBar.frame), 0);
//            searchVC.searchResultsTableView.tableFooterView = [[UIView alloc] init];
//            searchVC.searchResultsDataSource = self;
//            searchVC.searchResultsDelegate = self;
//            if (kHigher_iOS_6_1) {
//                searchVC.displaysSearchBarInNavigationBar = NO;
//            }
//            searchVC;
//        });
//    }
//    [_mySearchBar becomeFirstResponder];
}

#pragma make - tableviewcell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 56, ScreenWidth, ScreenHeight/4)];
    _imageLogo.backgroundColor = [UIColor colorWithRed:(247.0 / 255.0) green:(247.0 / 255.0) blue:(240.0 / 255.0) alpha:1.0f];
    [_imageLogo setImage:[UIImage imageNamed:@"homeImageLogo"]];
    return _imageLogo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithRed:(247/255) green:(247/255) blue:(240/255) alpha:0.2f];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"information", @"picture", @"dowenload", @"city", @"music",@"map",@"payment",@"share",@"chart"][indexPath.row]];
    cell.textLabel.text = @[@"信息表单", @"图片列表", @"文件下载", @"城市选择", @"音乐播放", @"地图",@"支付",@"分享",@"聊天"][indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)viewDidLayoutSubviews
{
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        PersonalInformationViewController *personalInformation = [[PersonalInformationViewController alloc] init];
        [self.navigationController pushViewController:personalInformation animated:YES];
       
    }else if (indexPath.row == 3){
        
        AddressPickerViewController *addressPicker_vc = [[AddressPickerViewController alloc] init];
        [self.navigationController pushViewController:addressPicker_vc animated:YES];
        
    }else if(indexPath.row == 5) {
       
        SigleLocationViewController *map_vc = [[SigleLocationViewController alloc] init];
        [self.navigationController pushViewController:map_vc animated:YES];
    
    }else if (indexPath.row == 6) {
        
        PingPayWebViewController *pay_vc = [[PingPayWebViewController alloc] init];
        pay_vc.titleText = @"支付";
        NSString *str = [NSString stringWithFormat:@"http://api.eshow.org.cn/pingpay/pay.jsp?accessToken=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenLogin"]];
        pay_vc.urlString = str;
        [self.navigationController pushViewController:pay_vc animated:YES];
        
    }else if (indexPath.row == 7) {
    
        ShareViewController *share_vc = [[ShareViewController alloc] init];
        [self.navigationController pushViewController:share_vc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

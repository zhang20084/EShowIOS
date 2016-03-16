//
//  AddressPickerViewController.h
//  EShowIOS
//
//  Created by 金璟 on 16/3/10.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "JJAddressPickerController.h"
#import "ChineseToPinyin.h"
#import "AddressHeader.h"
#import "CurrentCityCell.h"
#import "RecentCityCell.h"
#import "HotCityCell.h"


@interface JJAddressPickerController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    NSArray *hotCities;
    NSMutableArray *cities;
    NSMutableArray *titleArray;
    NSMutableArray *resultArray;
}

@property(nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation JJAddressPickerController

/**
 *  初始化方法
 *
 *  @param frame
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        [self initData];
        [self initSearchBar];
        [self initTableView];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:currentCity];
    }
    return self;
}

#pragma mark - Getter and Setter
- (void)setDataSource:(id<JJAddressPickerDataSource>)dataSource{
    hotCities = [dataSource arrayOfHotCitiesInAddressPicker:self];
    [_tableView reloadData];
}

#pragma mark - UISearchBar Delegate
/**
 *  搜索开始回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view setBackgroundColor:UIColorFromRGBA(198, 198, 203, 1.0)];
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                }
            }];
        }
    }
    return YES;
}

/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(endSearch:)]) {
        [self.delegate endSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            } completion:^(BOOL finished) {
                [self.view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
    }
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [resultArray removeAllObjects];
    for (int i = 0; i < cities.count; i++) {
        if ([[ChineseToPinyin pinyinFromChiniseString:cities[i]] hasPrefix:[searchString uppercaseString]] || [cities[i] hasPrefix:searchString]) {
            [resultArray addObject:[cities objectAtIndex:i]];
        }
    }
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return [[self.dictionary allKeys] count] + 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section > 2) {
            NSString *cityKey = [titleArray objectAtIndex:section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            return [array count];
        }
        return 1;
    }else{
        return [resultArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            CurrentCityCell *currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
            if (currentCityCell == nil) {
                currentCityCell = [[CurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currentCityCell"];
            }
            currentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return currentCityCell;
        }else if (indexPath.section == 1){
            RecentCityCell *recentCityCell = [tableView dequeueReusableCellWithIdentifier:@"recentCityCell"];
            if (recentCityCell == nil) {
                recentCityCell = [[RecentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentCityCell"];
            }
            recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                recentCityCell.frame = CGRectMake(0, 0, 0, 0);
                [recentCityCell setHidden:YES];
            }
            return recentCityCell;
        }else if (indexPath.section == 2){
            HotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
            if (hotCell == nil) {
                hotCell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell" array:hotCities];
            }
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *Identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if ([cell isKindOfClass:[CurrentCityCell class]]) {
            [(CurrentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else if ([cell isKindOfClass:[RecentCityCell class]]){
            [(RecentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else if([cell isKindOfClass:[HotCityCell class]]){
            [(HotCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else{
            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }

    }else{
        cell.textLabel.text = [resultArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"当前",@"最近",@"热门", nil];
        for (int i = 0; i < [titleArray count]; i++) {
            NSString *title = [NSString stringWithFormat:@"    %@",[titleArray objectAtIndex:i]];
            [titleSectionArray addObject:title];
        }
        return titleSectionArray;
    }else{
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
        headerView.backgroundColor = UIColorFromRGBA(235, 235, 235, 1.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 28)];
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        if (section == 0) {
            label.text = @"当前城市";
        }else if (section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return nil;
            }
            label.text = @"最近访问城市";
        }else if (section == 2){
            label.text = @"热门城市";
        }else{
            label.text = [titleArray objectAtIndex:section - 3];
        }
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 1) {
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return 0.01;
            }
        }
        return 28;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        //如果第一次使用没有最近访问的城市则赢该行
        if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
            return 0.01;
        }
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 2) {
            return ceil((float)[hotCities count] / 3) * (BUTTON_HEIGHT + 15) + 15;
        }else if (indexPath.section > 2){
            return 42;
        }else if (indexPath.section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return 0;
            }
        }
        return BUTTON_HEIGHT + 30;
    }else{
        return 42;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        if (indexPath.section > 2) {
            NSString *cityKey = [titleArray objectAtIndex:indexPath.section - 3];
            NSArray *array = [self.dictionary objectForKey:cityKey];
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self saveCurrentCity:[array objectAtIndex:indexPath.row]];
                [self.delegate addressPicker:self didSelectedCity:[array objectAtIndex:indexPath.row]];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
            [self saveCurrentCity:[resultArray objectAtIndex:indexPath.row]];
            [self.delegate addressPicker:self didSelectedCity:[resultArray objectAtIndex:indexPath.row]];
        }
    }
}

//保存访问过的城市
- (void)saveCurrentCity:(NSString*)city{
    NSMutableArray *currentArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:currentCity]];
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
    if ([currentArray count] < 2 && ![currentArray containsObject:city]) {
        [currentArray addObject:city];
    }else{
        if (![currentArray containsObject:city]) {
            currentArray[1] = currentArray[0];
            currentArray[0] = city;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentArray forKey:currentCity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - init
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    [self.view addSubview:_tableView];
}

- (void)initSearchBar{
    resultArray = [[NSMutableArray alloc] init];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

- (void)initData{
    cities = [[NSMutableArray alloc] init];
    NSArray *allCityKeys = [self.dictionary allKeys];
    for (int i = 0; i < [self.dictionary count]; i++) {
        [cities addObjectsFromArray:[self.dictionary objectForKey:[allCityKeys objectAtIndex:i]]];
    }
    titleArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 26; i++) {
        if (i == 8 || i == 14 || i == 20 || i== 21) {
            continue;
        }
        NSString *cityKey = [NSString stringWithFormat:@"%c",i+65];
        [titleArray addObject:cityKey];
    }
}

#pragma mark - Getter and Setter
- (NSMutableDictionary*)dictionary{
    if (_dictionary == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        _dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return _dictionary;
}



@end
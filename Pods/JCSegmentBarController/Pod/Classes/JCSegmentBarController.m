//
//  JCSegmentBarController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarController.h"
#import <objc/runtime.h>

static const void *segmentBarControllerKey;
static const void *segmentBarItemKey;
static const void *badgeValueKey;

@interface JCSegmentBarController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation JCSegmentBarController

static NSString * const reuseIdentifier = @"contentCellId";

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    if (self = [self init]) {
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemCount = MIN(self.viewControllers.count, 5);// the 1 line can be completely displayed 5 JCSegmentBarItem
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self.segmentBar didSeletedSegmentBarItem:^(NSInteger index) {
        [self scrollToItemAtIndex:index animated:NO];
    }];
    [self.view addSubview:self.segmentBar];
    
    self.navigationController.navigationBar.translucent = self.segmentBar.translucent;
    
    CGFloat bottom = self.tabBarController ? self.tabBarController.tabBar.frame.size.height : 0;
    
    if (!self.segmentBar.translucent) {
        bottom += [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    }
    
    self.contentInset = UIEdgeInsetsMake(self.segmentBar.frame.origin.y + self.segmentBar.frame.size.height, 0, bottom, 0);
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIScrollView *scrollView = (UIScrollView *)((UIViewController *)self.viewControllers[indexPath.item]).view;
    scrollView.frame = cell.contentView.bounds;
    scrollView.contentInset = self.contentInset;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell.contentView addSubview:scrollView];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToItemAtIndex:fabs(scrollView.contentOffset.x/scrollView.frame.size.width) animated:NO];
}

#pragma mark -

- (void)associatedSegmentBarController
{
    for (UIViewController *vc in self.viewControllers) {
        objc_setAssociatedObject(vc, &segmentBarControllerKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)associatedSegmentItem:(JCSegmentBarItem *)item indexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self.viewControllers[indexPath.item], &segmentBarItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JCSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        _segmentBar = [[JCSegmentBar alloc] initWithFrame:CGRectZero];
    }
    
    return _segmentBar;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (self.selectedItem) {
        [self scrollToItemAtIndex:selectedIndex animated:NO];
    }
    
    _selectedIndex = MIN(MAX(selectedIndex, 0), (self.viewControllers.count - 1));
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index >= 0 && index < self.viewControllers.count && (index != self.selectedIndex || !self.selectedItem)) {
        JCSegmentBarItem *item = (JCSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        [self selected:item unSelected:self.selectedItem];
        
        [self adjustSegmentBarContentOffset:index];
      
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
        
        if ([self.delegate respondsToSelector:@selector(segmentBarController:didSelectItem:)]) {
            [self.delegate segmentBarController:self didSelectItem:item];
        }
    }
}

- (void)selected:(JCSegmentBarItem *)selectedItem unSelected:(JCSegmentBarItem *)unSelectedItem
{
    selectedItem.textColor = self.segmentBar.selectedTintColor;
    unSelectedItem.textColor = self.segmentBar.tintColor;
    
    CGFloat duration = unSelectedItem ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        selectedItem.transform = CGAffineTransformMakeScale(1.1, 1.1);
        unSelectedItem.transform = CGAffineTransformIdentity;
        
        CGRect frame = self.segmentBar.bottomLineView.frame;
        frame.origin.x = selectedItem.frame.origin.x + (selectedItem.frame.size.width - self.segmentBar.bottomLineView.frame.size.width)/2;
        self.segmentBar.bottomLineView.frame = frame;
    }];
    
    _selectedIndex = selectedItem.tag;
    self.selectedItem = selectedItem;
    self.selectedViewController = self.viewControllers[self.selectedIndex];
}

- (void)adjustSegmentBarContentOffset:(NSInteger)index
{
    if (self.viewControllers.count > self.itemCount) {
        CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width/self.itemCount;
        CGFloat offsetX = 0;
        
        if (index <= floor(self.itemCount/2)) {
            offsetX = 0;
        }
        else if (index >= (self.viewControllers.count - ceil(self.itemCount/2))) {
            offsetX = (self.viewControllers.count - self.itemCount) * itemWidth;
        }
        else {
            offsetX = (index - floor(self.itemCount/2)) * itemWidth;
        }
        
        [self.segmentBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

@end

#pragma mark - category

@implementation UIViewController (JCSegmentBarControllerItem)

- (JCSegmentBarController *)segmentBarController
{
    return objc_getAssociatedObject(self, &segmentBarControllerKey);
}

- (JCSegmentBarItem *)segmentBarItem
{
    return objc_getAssociatedObject(self, &segmentBarItemKey);
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &badgeValueKey, badgeValue, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)badgeValue
{
    return objc_getAssociatedObject(self, &badgeValueKey) ? : @"";
}

@end

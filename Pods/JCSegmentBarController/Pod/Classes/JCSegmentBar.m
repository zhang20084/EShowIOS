//
//  JCSegmentBar.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBar.h"
#import "JCSegmentBarItem.h"
#import "JCSegmentBarController.h"

@interface JCSegmentBar ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) JCSegmentBarController *segmentBarController;

@property (nonatomic, copy) JCSegmentBarItemSeletedBlock seletedBlock;

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation JCSegmentBar

static NSString * const reuseIdentifier = @"segmentBarItemId";

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[JCSegmentBarItem class] forCellWithReuseIdentifier:reuseIdentifier];
        
        self.barTintColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1];
        self.tintColor = [UIColor darkGrayColor];
        self.selectedTintColor = [UIColor redColor];
        self.translucent = YES;
        self.height = 36.0f;
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    self.segmentBarController = (JCSegmentBarController *)[self getViewController];
    
    self.itemWidth = [UIScreen mainScreen].bounds.size.width/MIN(self.segmentBarController.viewControllers.count, 5);
    
    CGFloat segmentBarWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (self.translucent) {
        self.alpha = 0.96;
        CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + self.segmentBarController.navigationController.navigationBar.frame.size.height;
        self.frame = CGRectMake(0, y, segmentBarWidth, self.height);
    }
    else {
        self.alpha = 1;
        self.frame = CGRectMake(0, 0, segmentBarWidth, self.height);
    }
    
    self.bottomLineView.frame = CGRectMake((self.itemWidth-self.itemWidth*0.7)/2, self.frame.size.height-2, self.itemWidth*0.7, 2);

    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    [self.segmentBarController performSelector:@selector(associatedSegmentBarController) withObject:nil];
    #pragma clang diagnostic pop
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, self.frame.size.height-0.5, self.contentSize.width, 0.5);
}

- (void)didSeletedSegmentBarItem:(JCSegmentBarItemSeletedBlock)seletedBlock
{
    self.seletedBlock = seletedBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.segmentBarController.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.itemWidth, self.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.segmentBarController.viewControllers[indexPath.item];

    JCSegmentBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    item.tag = indexPath.item;
    item.badgeColor = self.selectedTintColor;
 
    if (vc.badgeValue && ![vc.badgeValue isEqualToString:@""]) {
        item.title = [NSString stringWithFormat:@"%@ %@", vc.title, vc.badgeValue];
    }
    else {
        item.title = vc.title;
    }
    
    item.textColor = self.tintColor;
   
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored"-Wundeclared-selector"
    [self.segmentBarController performSelector:@selector(associatedSegmentItem:indexPath:) withObject:item withObject:indexPath];
    #pragma clang diagnostic pop

    NSInteger selectedIndex = self.segmentBarController.selectedIndex;
    
    if (self.segmentBarController.selectedItem) {
        if (selectedIndex == indexPath.item) {
            [self.segmentBarController scrollToItemAtIndex:selectedIndex animated:NO];
        }
    }
    else {
        if ((selectedIndex + 1) == indexPath.item) {
            [self.segmentBarController scrollToItemAtIndex:selectedIndex animated:NO];
        }
    }
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seletedBlock) {
        self.seletedBlock(indexPath.item);
    }
}

#pragma mark -

- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    
    self.backgroundColor = _barTintColor;
}

- (void)setSelectedTintColor:(UIColor *)selectedTintColor
{
    _selectedTintColor = selectedTintColor;
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_bottomLineView];
    }
    
    _bottomLineView.backgroundColor = _selectedTintColor;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_lineView];
    }
    
    return _lineView;
}

- (UIViewController *)getViewController
{
    UIResponder *responder = [self nextResponder];
    
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}

@end

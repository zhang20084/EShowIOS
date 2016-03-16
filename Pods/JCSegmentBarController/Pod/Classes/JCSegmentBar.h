//
//  JCSegmentBar.h
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSegmentBarItem;
typedef void (^JCSegmentBarItemSeletedBlock)(NSInteger index);

@interface JCSegmentBar : UICollectionView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *selectedTintColor;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, assign) BOOL translucent;

- (void)didSeletedSegmentBarItem:(JCSegmentBarItemSeletedBlock)seletedBlock;

@end

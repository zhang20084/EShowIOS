//
//  JCSegmentBarController.h
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSegmentBar.h"
#import "JCSegmentBarItem.h"

@class JCSegmentBarController;
@protocol JCSegmentBarControllerDelegate<NSObject>
@optional
- (void)segmentBarController:(JCSegmentBarController *)segmentBarController didSelectItem:(JCSegmentBarItem *)item;
@end

@interface JCSegmentBarController : UIViewController

@property (nonatomic, strong) JCSegmentBar *segmentBar;

@property (nonatomic, weak) id<JCSegmentBarControllerDelegate> delegate;

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) JCSegmentBarItem *selectedItem;
@property (nonatomic, weak) UIViewController *selectedViewController;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

@interface UIViewController (JCSegmentBarControllerItem)

@property (nonatomic, copy) NSString *badgeValue;

@property (nonatomic, strong, readonly) JCSegmentBarItem *segmentBarItem;
@property (nonatomic, strong, readonly) JCSegmentBarController *segmentBarController;

@end

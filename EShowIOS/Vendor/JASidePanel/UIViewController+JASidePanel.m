//
//  UIViewController+JASidePanel.m
//  瑶瑶切克闹
//
//  Created by 金璟 on 16/4/6.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import "UIViewController+JASidePanel.h"

#import "JASidePanelController.h"

@implementation UIViewController (JASidePanel)

- (JASidePanelController *)sidePanelController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[JASidePanelController class]]) {
            return (JASidePanelController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end

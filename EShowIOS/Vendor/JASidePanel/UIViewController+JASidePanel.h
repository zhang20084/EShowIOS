//
//  UIViewController+JASidePanel.h
//  瑶瑶切克闹
//
//  Created by 金璟 on 16/4/6.
//  Copyright © 2016年 金璟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JASidePanelController;

/* This optional category provides a convenience method for finding the current
 side panel controller that your view controller belongs to. It is similar to the
 Apple provided "navigationController" and "tabBarController" methods.
 */
@interface UIViewController (JASidePanel)

// The nearest ancestor in the view controller hierarchy that is a side panel controller.
@property (nonatomic, weak, readonly) JASidePanelController *sidePanelController;

@end

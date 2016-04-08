//
//  UITapImageView.h
//  EShowIOS
//
//  Created by 金璟 on 16/2/25.
//  Copyright © 2016年 JinJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView
- (void)addTapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;
@end

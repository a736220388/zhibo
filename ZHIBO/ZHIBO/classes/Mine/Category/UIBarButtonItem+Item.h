//
//  UIBarButtonItem+Item.h
//  ZHIBO
//
//  Created by qianfeng on 16/9/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
//高亮
+ (instancetype)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;
//选中
+ (instancetype)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

@end

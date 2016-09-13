//
//  UIView+XJExtension.h
//  ZHIBO
//
//  Created by qianfeng on 16/9/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XJExtension)

@property (nonatomic, assign) CGFloat xj_width;
@property (nonatomic, assign) CGFloat xj_height;
@property (nonatomic, assign) CGFloat xj_x;
@property (nonatomic, assign) CGFloat xj_y;
@property (nonatomic, assign) CGFloat xj_centerX;
@property (nonatomic, assign) CGFloat xj_centerY;

@property (nonatomic, assign) CGFloat xj_right;
@property (nonatomic, assign) CGFloat xj_bottom;

+ (instancetype)viewFromXib;

@end

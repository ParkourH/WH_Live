//
//  UIView+Frame.m
//  01-UIView、UIWindow
//
//  Created by ParkourH on 16/7/14.
//  Copyright © 2016年 QC.L. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

// 原点的x
// set方法
- (void)setWh_x:(CGFloat)wh_x {

    CGRect rect = self.frame;
    rect.origin.x = wh_x;
    self.frame = rect;
}
// get方法
- (CGFloat)wh_x {

    return self.frame.origin.x;
}

// 原点的y
// set方法
- (void)setWh_y:(CGFloat)wh_y {

    CGRect rect = self.frame;
    rect.origin.y = wh_y;
    self.frame = rect;
}
// get方法
- (CGFloat)wh_y {

    return self.frame.origin.y;
}
// view的width
// set方法
- (void)setWh_width:(CGFloat)wh_width {

    CGRect rect = self.frame;
    rect.size.width = wh_width;
    self.frame = rect;
}
// get方法
- (CGFloat)wh_width {

    return self.frame.size.width;
}
// view的height
// set方法
- (void)setWh_height:(CGFloat)wh_height {

    CGRect rect = self.frame;
    rect.size.height = wh_height;
    self.frame = rect;
}
// get方法
- (CGFloat)wh_height {

    return self.frame.size.height;
}

/** 中心点 */
//X
// set方法
- (void)setWh_centerX:(CGFloat)wh_centerX {

    CGPoint center = self.center;
    center.x = wh_centerX;
    
    self.center = center;
}
// get方法
- (CGFloat)wh_centerX {

    return self.center.x;
}

//Y
// set方法
- (void)setWh_centerY:(CGFloat)wh_centerY {

    CGPoint center = self.center;
    center.y = wh_centerY;
    
    self.center = center;

}
// get方法
- (CGFloat)wh_centerY {

    return self.center.y;
}

@end

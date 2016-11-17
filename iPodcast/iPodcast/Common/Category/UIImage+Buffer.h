//
//  UIImage+Buffer.h
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Buffer)

// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;

@end

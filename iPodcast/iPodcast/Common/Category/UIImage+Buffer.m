//
//  UIImage+Buffer.m
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "UIImage+Buffer.h"

@implementation UIImage (Buffer)

+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName {

    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end

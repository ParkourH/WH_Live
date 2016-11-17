//
//  Ipodcast.h
//  iPodcast
//
//  Created by ParkourH on 16/10/19.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#ifndef Ipodcast_h
#define Ipodcast_h
// 调试打印
#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...)
#endif

#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_5         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_5         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_5_OR_HIGHER         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height >= 568.0f)
#define IS_IPHONE_6         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)

#define SCREEN_RECT         [UIScreen mainScreen].bounds
#define SCREEN_SIZE         [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH        SCREEN_SIZE.width
#define SCREEN_HEIGHT       SCREEN_SIZE.height

#define kRandColor [UIColor colorWithRed:arc4random() % 256/255.0f green:arc4random() % 256/255.0f blue:arc4random() % 256/255.0f alpha:1];

#define kSystemColor [UIColor colorWithRed:0.00 green:0.70 blue:0.59 alpha:1.00]
#define APP_ID @"LuurvM4OW5nAxMk3f3xvENxC-gzGzoHsz"
#define APP_KEY @"PRd8aPbjKWM5MWehoXxSB6lw"
#define  LoadBaseURL @"http://media.meelive.cn/m4a_64/"


/** 导入第三方 */

#import "AFNetworking.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "LeanCloudSocial/AVOSCloudSNS.h"
#import "AVOSCloud/AVOSCloud.h"
#import "UAProgressView.h"
#import "UMMobClick/MobClick.h"
/** 导入类目 */
#import "UIView+Frame.h"

/** 导入tool */
#import "ZWYNetTool.h"

#endif /* Ipodcast_h */

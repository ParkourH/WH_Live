//
//  PresentModelAble.h
//  PresentDemo
//
//  Created by 阮思平 on 16/10/2.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import <Foundation/Foundation.h>

// 日志

#ifdef DEBUG

#ifndef DebugLog
#define DebugLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#else

#ifndef DebugLog
#define DebugLog(fmt, ...)
#endif

#define NSLog


#endif

/**
 *  礼物模型必须遵守的协议
 */
@protocol PresentModelAble <NSObject>

@required
/**
 *  发送者
 */
@property (copy, nonatomic) NSString *sender;
/**
 *  礼物名
 */
@property (copy, nonatomic) NSString *giftName;

@end

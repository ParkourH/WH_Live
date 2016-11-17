//
//  WH_MusicModel.h
//  iPodcast
//
//  Created by ParkourH on 16/10/28.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import <CoreGraphics/CoreGraphics.h>

@class WH_MusicOperation;
typedef NS_ENUM(NSInteger, WH_MusicStatus) {
    
    kWHMusicStatusNone = 0,             // 初始状态
    kWHMusicStatusRunning = 1,          // 下载中
    kWHMusicStatusSuspended = 2,        // 下载暂停
    kWHMusicStatusCompleted = 3,        // 下载完成
    kWHMusicStatusFailed = 4,           // 下载失败
    kWHMusicStatusWaiting = 5,          // 等待下载
    //    kWHMusicStatusCancel = 6            // 取消下载
    
};


@interface WH_Singer : NSObject <NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;

@end

@interface WH_Lyric : NSObject <NSCoding>
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *url;

@end

@interface WH_Audio : NSObject <NSCoding>

@property (nonatomic, assign) BOOL has_full_url;

@property (nonatomic, assign) NSInteger length;

@property (nonatomic, copy) NSString *quality;

@property (nonatomic, copy) NSString *url;

@end

@interface WH_Track : NSObject <NSCoding>

@property (nonatomic, strong) WH_Audio *audio;
@property (nonatomic, strong) WH_Lyric *lyric;
@property (nonatomic, strong) WH_Singer *singer;
@property (nonatomic, assign) NSInteger WH_ID;

@property (nonatomic, copy) NSString *name;


typedef void(^WHMusicStatusChanged)(WH_Track *model);
typedef void(^WHMusicProgressChanged)(WH_Track *model);

/** 下载所需 */
@property (nonatomic, strong) NSData *resumeData;

/** 下载后存储到此处 */
@property (nonatomic, copy) NSString *localPath;

@property (nonatomic, copy) NSString *progressText;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) WH_MusicStatus status;
@property (nonatomic, strong) WH_MusicOperation *operation;

@property (nonatomic, copy) WHMusicStatusChanged onStatusChanged;
@property (nonatomic, copy) WHMusicProgressChanged onProgressChanged;

@property (nonatomic, copy) NSString *statusText;


@end

@interface WH_Results : NSObject

@property (nonatomic, copy) NSString *math;

@property (nonatomic, strong) WH_Track *track;

@end

@interface WH_MusicModel : NSObject

@property (nonatomic, assign) NSInteger dm_error;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *error_msg;
@property (nonatomic, strong) NSArray<WH_Results *> *results;

@end

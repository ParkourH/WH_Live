//
//  WH_MusicModel.m
//  iPodcast
//
//  Created by ParkourH on 16/10/28.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_MusicModel.h"
#import "MJExtension.h"
#import "WH_MusicOperation.h"

@implementation WH_Singer
/** 取值 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _name = [aDecoder decodeObjectForKey:@"musicID"];
        
        
        _photo = [aDecoder decodeObjectForKey:@"musicBackImage"];
        
    }
    return self;
}

/** 赋值 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_name forKey:@"musicID"];
    
    
    [aCoder encodeObject:_photo forKey:@"musicBackImage"];
}


@end

@implementation WH_Lyric
#pragma mark ------------  下载后的写入  -----------
/** 取值 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _type = [aDecoder decodeObjectForKey:@"musicID"];
        
        
        _url = [aDecoder decodeObjectForKey:@"musicBackImage"];
        
    }
    return self;
}

/** 赋值 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_type forKey:@"musicID"];
    
    
    [aCoder encodeObject:_url forKey:@"musicBackImage"];
}


@end

@implementation WH_Audio
#pragma mark ------------  下载后的写入  -----------
/** 取值 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        
        _quality = [aDecoder decodeObjectForKey:@"musicTitle"];;
        _length = [aDecoder decodeIntegerForKey:@"length"];
        _url = [aDecoder decodeObjectForKey:@"musicBackImage"];
        
    }
    return self;
}

/** 赋值 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    
    [aCoder encodeObject:_quality forKey:@"musicTitle"];
    [aCoder encodeInteger:_length forKey:@"length"];
    [aCoder encodeObject:_url forKey:@"musicBackImage"];
}


@end

@implementation WH_Track

#pragma mark ------------  下载后的写入  -----------
/** 取值 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _audio = [aDecoder decodeObjectForKey:@"musicID"];
        _lyric = [aDecoder decodeObjectForKey:@"musicTitle"];;
        _singer = [aDecoder decodeObjectForKey:@"musicUserName"];
        _name = [aDecoder decodeObjectForKey:@"musicBackImage"];
        _WH_ID = [aDecoder decodeIntegerForKey:@"WH_ID"];
    }
    return self;
}

/** 赋值 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_audio forKey:@"musicID"];
    [aCoder encodeObject:_lyric forKey:@"musicTitle"];
    [aCoder encodeObject:_singer forKey:@"musicUserName"];
    [aCoder encodeObject:_name forKey:@"musicBackImage"];
    [aCoder encodeInteger:_WH_ID forKey:@"WH_ID"];
}



+ (NSDictionary *)mj_replacedKeyFromPropertyName {

    return @{@"WH_ID":@"id"};
}

#pragma mark ------------  下载用的  -----------
- (NSString *)localPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *pathName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)  lastObject];
    NSString *filePath = [pathName stringByAppendingPathComponent:@"loadPath"];
    [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];

    return filePath;
}

- (void)setProgress:(CGFloat)progress {
    
    if (_progress != progress) {
        
        _progress = progress;
        
        if (self.onProgressChanged) {
            
            self.onProgressChanged(self);
        } else {
            
            NSLog(@"progress changed block is empty");
        }
    }
}

- (void)setStatus:(WH_MusicStatus)status {
    
    if (_status != status) {
        
        _status = status;
        
        if (self.onStatusChanged) {
            
            self.onStatusChanged(self);
        }
    }
}


- (NSString *)statusText {
    switch (self.status) {
        case kWHMusicStatusNone: {
            return @"";
            break;
        }
        case kWHMusicStatusRunning: {
            return @"下载中";
            break;
        }
        case kWHMusicStatusSuspended: {
            return @"暂停下载";
            break;
        }
        case kWHMusicStatusCompleted: {
            return @"下载完成";
            break;
        }
        case kWHMusicStatusFailed: {
            return @"下载失败";
            break;
        }
        case kWHMusicStatusWaiting: {
            return @"等待下载";
            break;
        }
    }
}


@end

@implementation WH_Results


@end

@implementation WH_MusicModel

- (void)setValue:(id)value forKey:(NSString *)key {

    NSMutableArray *mArr = [NSMutableArray array];
    if ([key isEqualToString:@"results"]) {
        
        for (NSDictionary *dic in value) {
            
            WH_Results *results = [WH_Results mj_objectWithKeyValues:dic];
            [mArr addObject:results];
        }
        self.results = mArr;
        
    }
}



@end

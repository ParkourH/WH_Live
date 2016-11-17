//
//  WH_MusicManager.h
//  ForAMoment
//
//  Created by ParkourH on 16/9/19.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WH_Track;
@interface WH_MusicManager : NSObject

@property (nonatomic, strong) NSArray *musicModels;

+ (instancetype)sharedManager;

- (void)addMusicModels:(NSArray<WH_Track *> *)musicModels;

- (void)startWithMusicModel:(WH_Track *)musicModel;
- (void)suspendWithMusicModel:(WH_Track *)musicModel;
- (void)resumeWithMusicModel:(WH_Track *)musicModel;
- (void)stopWithMusicModel:(WH_Track *)musicModel;

@end

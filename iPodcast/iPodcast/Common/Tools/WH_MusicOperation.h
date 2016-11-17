//
//  WH_MusicOperation.h
//  ForAMoment
//
//  Created by ParkourH on 16/9/19.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WH_Track;

@interface NSURLSessionTask (TingModel)

@property (nonatomic, strong) WH_Track *tingModel;

@end



@interface WH_MusicOperation : NSOperation

- (instancetype)initWithModel:(WH_Track *)model session:(NSURLSession *)session;

@property (nonatomic, strong) WH_Track *model;

@property (nonatomic, strong) NSURLSessionDownloadTask *downLoadTask;

- (void)suspend;

- (void)resume;

- (void)downLoadFinished;

@end


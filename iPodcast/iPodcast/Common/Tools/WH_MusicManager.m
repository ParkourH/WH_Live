//
//  WH_MusicManager.m
//  ForAMoment
//
//  Created by ParkourH on 16/9/19.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_MusicManager.h"
#import "WH_MusicModel.h"
#import "WH_MusicOperation.h"

static WH_MusicManager *_sg_musicManager = nil;

@interface WH_MusicManager () <NSURLSessionDownloadDelegate>{

    NSMutableArray *_musicModels;
    
}

@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSMutableArray *mArrOfLoadMusic;

@property (nonatomic, copy) NSString *modelPath;
@end


@implementation WH_MusicManager

+ (instancetype)sharedManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sg_musicManager = [[self alloc] init];
    });
    
    return _sg_musicManager;
}

- (instancetype)init {

    self = [super init];
    if (self) {
       
        
        BOOL isExist = [self isHaveMusicModelArray];
        if (!isExist) {
            
            _mArrOfLoadMusic = [NSMutableArray array];
        } else {
        
            _mArrOfLoadMusic = [[NSKeyedUnarchiver unarchiveObjectWithFile:_modelPath] mutableCopy];
            
        }
        _musicModels = [NSMutableArray array];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 4;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 不能传self.queue
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (BOOL)isHaveMusicModelArray {

    self.modelPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)   lastObject] stringByAppendingPathComponent:@"loadPath"] stringByAppendingPathComponent:@"model.plist"];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:_modelPath];
}


- (NSArray *)musicModels {

    return _musicModels;
}

- (void)addMusicModels:(NSArray<WH_Track *> *)musicModels {

    if ([musicModels isKindOfClass:[NSArray class]]) {
        [_musicModels addObjectsFromArray:musicModels];
    }
}

- (void)startWithMusicModel:(WH_Track *)musicModel {

    if (musicModel.status != kWHMusicStatusCompleted) {
        
        musicModel.status = kWHMusicStatusRunning;
        
        if (musicModel.operation == nil) {
            
            musicModel.operation = [[WH_MusicOperation alloc] initWithModel:musicModel session:self.session];
            
            [self.queue addOperation:musicModel.operation];
            [musicModel.operation start];
        } else {
        
            [musicModel.operation resume];
        }
    }
}

- (void)suspendWithMusicModel:(WH_Track *)musicModel {

    if (musicModel.status != kWHMusicStatusCompleted) {
        
        [musicModel.operation suspend];
    }
}


- (void)resumeWithMusicModel:(WH_Track *)musicModel {

    if (musicModel.status != kWHMusicStatusCompleted) {
        
        [musicModel.operation resume];
    }
}


- (void)stopWithMusicModel:(WH_Track *)musicModel {

    if (musicModel.operation) {
        
        [musicModel.operation cancel];
    }
}

#pragma mark ------------  NSURLSessionDownDelegate  -----------
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

    // 本地文件路径, 使用fileURLWithPath:来创建
    if (downloadTask.tingModel.localPath) {
    
//        NSFileManager *manager = [NSFileManager defaultManager];
//        NSString *pathName = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)   lastObject];
//        NSString *filePath = [pathName stringByAppendingPathComponent:@"loadPath"];
//        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//        
//        
//        NSString *loadFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", downloadTask.tingModel.audio.url]];
//        NSURL *toURL = [NSURL fileURLWithPath:loadFilePath];
    NSURL *toURL = [NSURL fileURLWithPath:downloadTask.tingModel.localPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    [_mArrOfLoadMusic addObject:downloadTask.tingModel];
        
        
        BOOL isModelWriteSuccess = [NSKeyedArchiver archiveRootObject:_mArrOfLoadMusic toFile:_modelPath];
        
        if (isModelWriteSuccess) {
            
            NSLog(@"写入Model成功");
            NSLog(@"%@", _modelPath);
        } else {
        
            NSLog(@"写入Model失败");
        }
        
        
    [manager moveItemAtURL:location toURL:toURL error:nil];
    NSLog(@"path = %@", toURL);
    }
    [downloadTask.tingModel.operation downLoadFinished];
    NSLog(@"path = %@", downloadTask.tingModel.localPath);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

   dispatch_async(dispatch_get_main_queue(), ^{
       
       if (error == nil) {
           
           task.tingModel.status = kWHMusicStatusCompleted;
           [task.tingModel.operation downLoadFinished];
       } else if (task.tingModel.status == kWHMusicStatusSuspended) {
           
           task.tingModel.status = kWHMusicStatusSuspended;
       } else if ([error code] < 0) {
           
           // 网络异常
           task.tingModel.status = kWHMusicStatusFailed;
       }
   });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {

    double byts = totalBytesWritten * 1.0 / 1024 / 1024;
    double total = totalBytesExpectedToWrite * 1.0 / 1024 /1024;
    NSString *text = [NSString stringWithFormat:@"%.1lfMB/%.1fMB", byts, total];
    
    CGFloat progress = totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        downloadTask.tingModel.progressText = text;
        downloadTask.tingModel.progress = progress;
    });
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {

    double byts = fileOffset * 1.0 / 1024 / 1024;
    double total = expectedTotalBytes * 1.0 / 1024 / 1024;
    NSString *text = [NSString stringWithFormat:@"%.1fMB/%.1fMB", byts, total];
    
    CGFloat progress = fileOffset / (CGFloat)expectedTotalBytes;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        downloadTask.tingModel.progressText = text;
        downloadTask.tingModel.progress = progress;
    });
}



@end

//
//  WH_MusicOperation.m
//  ForAMoment
//
//  Created by ParkourH on 16/9/19.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_MusicOperation.h"
#import "WH_MusicModel.h"
#import <objc/runtime.h>

#define kKVOBlock(KEYPATH, BLOCK) \
[self willChangeValueForKey:KEYPATH]; \
BLOCK(); \
[self didChangeValueForKey:KEYPATH];

@interface WH_MusicOperation (){

    BOOL _finished;
    BOOL _executing;
}

@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSURLSession *session;

@end

static NSTimeInterval kTimeoutInteral = 60.0;

@implementation WH_MusicOperation

- (instancetype)initWithModel:(WH_Track *)model session:(NSURLSession *)session {

    self = [super init];
    if (self) {
        
        self.model = model;
        self.session = session;
        [self startRequest];
    }
    return self;
}

- (void)setTask:(NSURLSessionDownloadTask *)task {

    [_task removeObserver:self forKeyPath:@"state"];
    
    if (_task != task) {
        
        _task = task;
    }
    
    if (task != nil) {
        
        [task addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)configTask {

    self.task.tingModel = self.model;
}

- (void)startRequest {

    NSURL *url = [NSURL URLWithString:[@"http://media.meelive.cn/m4a_64/" stringByAppendingString:self.model.audio.url]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTimeoutInteral];
    self.task = [self.session downloadTaskWithRequest:request];
    
    [self configTask];
}

- (void)start {

    if (self.isCancelled) {
        
        kKVOBlock(@"isFinished", ^{
            
            _finished = YES;
        });
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    if (self.model.resumeData) {
        
        [self resume];
    } else {
    
        [self.task resume];
        self.model.status = kWHMusicStatusRunning;
    }
    
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {

    return _executing;
}

- (BOOL)isFinished {

    return _finished;
}

- (BOOL)isConcurrent {

    return YES;
}

- (void)suspend {

    if (self.task) {
        
        __weak __typeof(self) weakSelf = self;
        __block NSURLSessionDownloadTask *weakTask = self.task;
        [self willChangeValueForKey:@"isExecuting"];
        __block BOOL isExecuting = _executing;
        
        [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
           
            weakSelf.model.resumeData = resumeData;
            weakTask = nil;
            isExecuting = NO;
            [weakSelf didChangeValueForKey:@"isExecuting"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                weakSelf.model.status = kWHMusicStatusSuspended;
            });
        }];
      
        [self.task suspend];
    }
}

- (void)resume {

    if (self.model.status == kWHMusicStatusCompleted) {
        
        return;
    }
    self.model.status = kWHMusicStatusRunning;
    
    if (self.model.resumeData) {
        
        self.task = [self.session downloadTaskWithResumeData:self.model.resumeData];
        [self configTask];
    } else if (self.task == nil || (self.task.state == NSURLSessionTaskStateCompleted && self.model.progress < 1.0)) {
    
        [self startRequest];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self.task resume];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (NSURLSessionDownloadTask *)downLoadTask {

    return self.task;
}

- (void)cancel {

    [self willChangeValueForKey:@"isCanceled"];
    [super cancel];
    [self.task cancel];
    self.task = nil;
    [self didChangeValueForKey:@"isCanceled"];
    
    [self completeOperation];
}

- (void)completeOperation {

    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _executing = NO;
    _finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"state"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            switch (self.task.state) {
                case NSURLSessionTaskStateSuspended: {
                
                    self.model.status = kWHMusicStatusSuspended;
                    break;
                }
                case NSURLSessionTaskStateCompleted:
                    if (self.model.progress >= 1.0) {
                        
                        self.model.status = kWHMusicStatusCompleted;
                    } else {
                    
                        self.model.status = kWHMusicStatusSuspended;
                    }
                    
                default:
                    break;
            }
        });
    }
}


- (void)downLoadFinished {

    [self completeOperation];
}


- (void)dealloc {
    
    self.task = nil;
}

@end


static const void *s_wh_musicModelKey = "s_wh_musicModelKey";

@implementation NSURLSessionTask (TingModel)

- (void)setTingModel:(WH_Track *)tingModel {

    objc_setAssociatedObject(self, s_wh_musicModelKey, tingModel, OBJC_ASSOCIATION_ASSIGN);
}

- (WH_Track *)tingModel {

    return objc_getAssociatedObject(self, s_wh_musicModelKey);
}

@end

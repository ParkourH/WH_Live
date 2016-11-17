//
//  WH_PlayerViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/26.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_PlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "Ipodcast.h"
#import <Accelerate/Accelerate.h>
#import "WH_liveView.h"
#import "WH_HeartFlyView.h"
#import "LivesModel.h"
#import "WH_GiftBackView.h"
#import "WH_GiftModel.h"
#import "PresentView.h"
#import "WH_CustomCell.h"
#import "LoginAlertController.h"
#import "WH_PayViewController.h"
@interface WH_PlayerViewController () <PresentViewDelegate, LoginAlertDelegate>

/** 这里的atomic原子性是什么意思 */
@property (atomic, retain) id <IJKMediaPlayback>player;

@property (nonatomic, strong) UIView *playerView;

@property (atomic, strong) NSURL *url;

@property (nonatomic, assign) CGFloat heartSize;

@property (nonatomic, strong) UIImageView *dimImage;

//@property (nonatomic, strong) NSArray *fireWorksArray;

@property (nonatomic, strong) WH_liveView *lookView;

/** 送礼物弹出来的 */
@property (nonatomic, strong) WH_GiftBackView *giftBackView;
/** 礼物动画所在的View */
@property (nonatomic, strong) PresentView *presentView;


@property (nonatomic, strong) WH_GiftModel *modelOfGift;
@end

//static WH_PlayerViewController *_livePlayer = nil;

static CGFloat height = 0;
@implementation WH_PlayerViewController

//+ (instancetype)sharePlayer {
//
//    if (_livePlayer == nil) {
//        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            
//            _livePlayer = [[WH_PlayerViewController alloc] init];
//        });
//    }
//    return _livePlayer;
//}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ------------  viewWillAppear  -----------
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    
}

#pragma mark ------------  创建礼物所在的View  -----------
- (void)createGiftView {

    self.presentView = [[PresentView alloc] init];
    [self.view addSubview:_presentView];
    [_presentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT / 4);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.6);
        make.height.mas_equalTo(SCREEN_HEIGHT / 4);
    }];
    self.presentView.delegate = self;
    self.presentView.backgroundColor = [UIColor clearColor];
}

#pragma mark ------------  PresentView的代理方法  -----------
- (PresentViewCell *)presentView:(PresentView *)presentView cellOfRow:(NSInteger)row {

    return [[WH_CustomCell alloc] initWithRow:row];
}

- (void)presentView:(PresentView *)presentView configCell:(PresentViewCell *)cell sender:(NSString *)sender giftName:(NSString *)name {

   
    WH_CustomCell *customCell = (WH_CustomCell *)cell;
    customCell.model = _modelOfGift;
}

- (void)presentView:(PresentView *)presentView didSelectedCellOfRowAtIndex:(NSUInteger)index {

//    WH_CustomCell *cell = [presentView cellForRowAtIndex:index];
}
#pragma mark ------------  开始播放  -----------
- (void)playing {

    // 获取url
    self.url = [NSURL URLWithString:_model.stream_addr];
//    self.url = [NSURL URLWithString:@"http://play.lss.qupai.me/melive/melive-20SH5.flv?auth_key=1477710976-0-2836-2b0a776be0d83ba4ad52fba385dc88af"];
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
    
    UIView *playerView = [self.player view];
    UIView *displayView = [[UIView alloc] initWithFrame:SCREEN_RECT];
    
    self.playerView = displayView;
    [self.view addSubview:self.playerView];
    
    // 自己调整自己的宽度和高度
    playerView.frame = self.playerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.playerView insertSubview:playerView atIndex:1];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
}

#pragma mark ------------  开启通知  -----------
- (void)installMovieNotificationObservers {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateDidChange:) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviewPlayBackFinish:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaIsPreparedToPlayDidChange:) name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviewPlayBackStateDidChange:) name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];

}

#pragma mark ------------  移除通知  -----------
- (void)removeMovieNotificationObservers {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
#pragma mark ------------  通知的四个方法  -----------
- (void)loadStateDidChange:(NSNotification *)noti {
    
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        NSLog(@"LoadStateDidChange:IJKMPMovieLoadStatePlaythroughOK:%ld\n", (unsigned long)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        
        NSLog(@"loadStateDidChange:IJKMPMovieLoadStateStalled: %ld\n", (unsigned long)loadState);
    } else {
        
        NSLog(@"loadStateDidChange: ???: %ld\n", (unsigned long)loadState);
    }
    
}

- (void)moviewPlayBackFinish:(NSNotification *)noti {
    
    NSInteger reason = [[[noti userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %ld\n", (long)reason);
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %ld\n", (long)reason);
            break;
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %ld\n", (long)reason);
            break;
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %ld\n", (long)reason);
            break;
    }
    
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)noti {
    
    NSLog(@"mediaIsPrePareToPlayDidChange\n");
}

- (void)moviewPlayBackStateDidChange:(NSNotification *)noti {
    
    _dimImage.hidden = YES;
    
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviewPlayBackStateDidChange %ld: stoped", (long)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %ld: playing", (long)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %ld: paused", (long)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %ld: interrupted", (long)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            
            NSLog(@"IJKMPMoviePlayBackStateDidChange %ld: seeking", (long)_player.playbackState);
            break;
        }
            
        default:
            break;
    }
}

#pragma mark ------------  设置加载视图  -----------
- (void)setUpLoadingView {

    self.dimImage = [[UIImageView alloc] initWithFrame:SCREEN_RECT];
    NSString *str = [NSString stringWithFormat:@"http://img.meelive.cn/%@",_model.creator.portrait];
    [_dimImage sd_setImageWithURL:[NSURL URLWithString:str]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = _dimImage.bounds;
    [_dimImage addSubview:visualEffectView];
    [self.view addSubview:_dimImage];
}

#pragma mark ------------  创建子视图  -----------
- (void)createSubViews {

    self.lookView = [[WH_liveView alloc] initWithFrame:SCREEN_RECT withVCType:Look];
    [self.view addSubview:_lookView];
    _lookView.model = self.model;
    _lookView.backgroundColor = [UIColor clearColor];
    __weak WH_PlayerViewController *weakSelf = self;
    _lookView.buttonAction = ^(UIButton *btn) {
        
        if (btn.tag == 888) {
            
            [weakSelf btnOfBackAction];
        } else if (btn.tag == 666) {
            
            [weakSelf sendGift];
        } else if (btn.tag == 555) {
        
            [weakSelf lightHeart:btn];
        }
    };
    
    height = (SCREEN_WIDTH - 8) / 4 * 1.3 * 2 + 2 + 50;
    self.giftBackView = [[WH_GiftBackView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
    [self.view addSubview:self.giftBackView];
    
    self.giftBackView.sendPresent = ^(UIButton *sender, WH_GiftModel *model, BOOL isEnough) {
        /** 上面已经定义了 */
        
        if (isEnough == YES && sender.tag == 7878) {
            
        
            _modelOfGift = model;
            if ([sender.backgroundColor isEqual:kSystemColor] && !      [model.giftName isEqualToString:@"保时捷"]) {
                
            [weakSelf sendGiftAnimation:model];
            
            } else if ([model.giftName isEqualToString:@"保时捷"] && [sender.backgroundColor isEqual:kSystemColor]) {
            
                [weakSelf createCarAnimation];
            }
                [weakSelf cancleSend];
        } else if (isEnough == NO && sender.tag == 7878) {
        
            [weakSelf createTipAlert];
        } else if (sender.tag == 1314) {
        
            [weakSelf gotoPay];
        }
    };
}

- (void)gotoPay {

    WH_PayViewController *payVC = [[WH_PayViewController alloc] initWithNibName:@"WH_PayViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark ------------  余额不足请充值  -----------
- (void)createTipAlert {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"余额不足, 是否去充值" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoPay];
    }];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionOK];
    [alert addAction:actionCancle];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}




// 送礼物
- (void)createCarAnimation {
    
    CGFloat durTime = 3.0;
    
    UIImageView *gift = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"porsche"]];
    
    //设置汽车的初始位置
    gift.frame = CGRectMake(0, 0, 0, 0);
    [self.view addSubview:gift];
    [UIView animateWithDuration:durTime animations:^{
        
        gift.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 100, self.view.bounds.size.height * 0.5 - 100 * 0.5, 240, 120);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            gift.alpha = 0;
        } completion:^(BOOL finished) {
            
            [gift removeFromSuperview];
        }];
    });
}



#pragma mark ------------  送礼物的动画  -----------
- (void)sendGiftAnimation:(WH_GiftModel *)model {

    [self.presentView insertPresentMessages:@[model] showShakeAnimation:YES];
}

#pragma mark ------------  返回 停止直播的方法  -----------
- (void)btnOfBackAction {
    
    [self.lookView removeFromSuperview];
    [self.presentView removeFromSuperview];
    [self.player shutdown];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------------  送礼物  -----------
- (void)sendGift {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
        
            self.lookView.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
            self.giftBackView.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        }];
    } else {
    
        LoginAlertController *alert = [[LoginAlertController alloc] init];
        alert.delegate = self;
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
}

- (void)clickConfirmButton:(LoginAlertController *)alert {

    NSLog(@"111");
}

#pragma mark ------------  点亮  -----------
- (void)lightHeart:(UIButton *)sender {

    _heartSize = 36;
    WH_HeartFlyView *heart = [[WH_HeartFlyView alloc] initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(_heartSize + _heartSize / 2.0, self.view.bounds.size.height - _heartSize / 2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button 点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"show"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 播放视屏
    [self playing];
    
    // 开启通知
    [self installMovieNotificationObservers];
    
    // 设置加载视图
    [self setUpLoadingView];
    
    // 创建视图
    [self createSubViews];
    
    // 创建礼物动画所在的View
    [self createGiftView];
    
    
    if (![self.player isPlaying]) {
        
        [self.player prepareToPlay];
    }

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGFloat y = point.y;
    if (y < (SCREEN_HEIGHT - height) || y > (SCREEN_HEIGHT - 50)) {
        
        [self cancleSend];
    }
}

#pragma mark ------------  取消礼物  -----------
- (void)cancleSend {

    [UIView animateWithDuration:0.25 animations:^{
        
        self.lookView.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60);
        self.giftBackView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

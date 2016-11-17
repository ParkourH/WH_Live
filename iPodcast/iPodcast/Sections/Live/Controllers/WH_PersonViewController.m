#import "WH_PersonViewController.h"
#import "Ipodcast.h"
#import <CoreLocation/CoreLocation.h>
#import <QPLive/QPLive.h>
//#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "WH_LiveViewController.h"
#import "WH_liveView.h"
#import <CallKit/CXCallObserver.h>
#import <CallKit/CallKit.h>
#import "WH_SeletedMusicViewController.h"
@interface WH_PersonViewController () <CLLocationManagerDelegate, QPLiveSessionDelegate, CXCallObserverDelegate>

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *imageViewOfLocation;

@property (nonatomic, strong) UILabel *labelOfLocation;

@property (nonatomic, strong) UISwitch *switchOfLocation;

@property (nonatomic, strong) UITextField *textFiledOfTitle;

@property (nonatomic, strong) UIButton *buttonOfStartLive;

/** 定位需要 */
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) NSString *currentCity;

@property (nonatomic, assign) BOOL isAllowLocation;

//@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, strong) CXCallObserver *callCenter;

/** 进入直播页面后最上面的View */
@property (nonatomic, strong) WH_liveView *liveView;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *labelOfTime;

@end

@implementation WH_PersonViewController{
    
    QPLiveSession *_liveSession;

    AVCaptureDevicePosition _currentPosition;
    
    CGFloat _lastPinchDistance;
    
    BOOL _isCTCallStateDisconnected;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.textFiledOfTitle becomeFirstResponder];
    
    [MobClick beginLogPageView:@"PageTwo"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [MobClick beginLogPageView:@"PageTwo"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#pragma mark ------------  这里先默认开启允许定位(如果一进来就允许这里就是yes一进来不允许(这里点击的on的时候询问))  -----------
    _isAllowLocation = YES;
    
    [self setup];
    
    [self createSubViews];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    [button setImage:[UIImage imageNamed:@"live_back"] forState:UIControlStateNormal];
    [button layoutIfNeeded];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.bounds.size.width / 2;
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [button addTarget:self action:@selector(dissmissAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setup {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    /** 添加点击手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    /** 添加捏合手势 */
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.view addGestureRecognizer:pinch];
    
    [self testPushCapture];
}

#pragma mark ------------  电话来了, app不是活跃状态  -----------
- (void)appResignActive {
    
    [self destorySession];
    
    // 监听电话
    _callCenter = [[CXCallObserver alloc] init];
    
    _isCTCallStateDisconnected = NO;
    [_callCenter setDelegate:self queue:nil];
}


- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {

    if (call.outgoing) {
        
        _isCTCallStateDisconnected = YES;
    } else if (call.isOnHold) {
    
         _callCenter = nil;
    }
}

#pragma mark ------------  消除任务  -----------
- (void)destorySession {
    
    // 推流断开连接
    [_liveSession disconnectServer];
    // 停止
    [_liveSession stopPreview];
    [_liveSession.previewView removeFromSuperview];
    
    _liveSession = nil;
}
#pragma mark ------------  app 变得活跃状态  -----------
- (void)appBecomeActive {
    
    if (_isCTCallStateDisconnected) {
        
        sleep(2);
    }
    [self testPushCapture];
}

#pragma mark ------------  app尝试推送视频  -----------
- (void)testPushCapture {
    
    QPLConfiguration *config = [[QPLConfiguration alloc] init];
    config.url = _url;
    config.videoMaxBitRate = 1500 * 1000;
    config.videoBitRate = 600 * 1000;
    config.videoMinBitRate = 400 * 1000;
    config.audioBitRate = 64 * 1000;
    config.videoSize = CGSizeMake(360, 640); //横屏状态宽高不需要互换
    config.fps = 20;
    config.preset = AVCaptureSessionPresetiFrame1280x720;
    // 手机横竖屏, 默认竖屏
    config.screenOrientation = 0;
    
    // 水印
    config.waterMaskImage = [UIImage imageNamed:@""];
    config.waterMaskLocation = 0;
    config.waterMaskMarginX = 20;
    config.waterMaskMarginY = 20;
    
    if (_currentPosition) {
        
        config.position = _currentPosition;
    } else {
        
        config.position = AVCaptureDevicePositionFront;
        _currentPosition = AVCaptureDevicePositionFront;
    }
    
    _liveSession = [[QPLiveSession alloc] initWithConfiguration:config];
    _liveSession.delegate = self;
    
    [_liveSession startPreview];
    
    [_liveSession updateConfiguration:^(QPLConfiguration *configuration) {
        
        config.videoMaxBitRate = 1500 * 1000;
        config.videoBitRate = 600 * 1000;
        config.videoMinBitRate = 400 * 1000;
        config.audioBitRate = 64 * 1000;
        config.fps = 20;
    }];
    // 推流连接
    [_liveSession connectServer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });
    QPLConfiguration *configuration = [[QPLConfiguration alloc] init];
    configuration.url = _url;
    configuration.videoMaxBitRate = 1500 * 1000;
    configuration.videoBitRate = 600 * 1000;
    configuration.videoMinBitRate = 400 * 1000;
    configuration.audioBitRate = 64 * 1000;
    configuration.videoSize = CGSizeMake(360, 640);// 横屏状态宽高不需要互换
    configuration.fps = 20;
    configuration.preset = AVCaptureSessionPresetiFrame1280x720;
    configuration.screenOrientation = 0;
    
    // 水印
    configuration.waterMaskImage = [UIImage imageNamed:@"watermask"];
    configuration.waterMaskLocation = 0;
    configuration.waterMaskMarginX = 20;
    configuration.waterMaskMarginY = 20;
    
    if (_currentPosition) {
        configuration.position = _currentPosition;
    } else {
        configuration.position = AVCaptureDevicePositionFront;
        _currentPosition = AVCaptureDevicePositionFront;
    }
    
    _liveSession = [[QPLiveSession alloc] initWithConfiguration:configuration];
    _liveSession.delegate = self;
    
    [_liveSession startPreview];
    
    [_liveSession updateConfiguration:^(QPLConfiguration *configuration) {
        configuration.videoMaxBitRate = 1500 * 1000;
        configuration.videoBitRate = 600 * 1000;
        configuration.videoMinBitRate = 400 * 1000;
        configuration.audioBitRate = 64 * 1000;
        configuration.fps = 20;
    }];
    [_liveSession connectServer];
    
    /** 开启美颜 */
    [_liveSession setEnableSkin:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view insertSubview:[_liveSession previewView] atIndex:0];
    });
    

}

#pragma mark ------------  点击的手势方法  -----------
- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:self.view];
    CGPoint percentPoint = CGPointZero;
    percentPoint.x = point.x / CGRectGetWidth(self.view.bounds);
    percentPoint.y = point.y / CGRectGetHeight(self.view.bounds);
    [_liveSession focusAtAdjustedPoint:percentPoint autoFocus:YES];
}

#pragma mark ------------  捏合手势方法(缩放的方法)  -----------
- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {
    
    if (_currentPosition == AVCaptureDevicePositionFront) {
        
        return;
    }
    if (pinch.numberOfTouches != 2) {
        
        return;
    }
    CGPoint p1 = [pinch locationOfTouch:0 inView:self.view];
    CGPoint p2 = [pinch locationOfTouch:1 inView:self.view];
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    CGFloat dist = sqrt(dx * dx + dy * dy);
    if (pinch.state == UIGestureRecognizerStateBegan) {
        
        _lastPinchDistance = dist;
    }
    CGFloat change = dist - _lastPinchDistance;
    [_liveSession zoomCamera:change / 1000];
}

#pragma mark ------------  QPLiveSessionDelegate的代理方法  -----------
- (void)liveSession:(QPLiveSession *)session error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *message = [NSString stringWithFormat:@"%zd %@", error.code, error.localizedDescription];
        [self alertController:@"提示" message:message leftTitle:@"重新连接" rightTitle:@"取消"];
        
    });
}

- (void)liveSessionNetworkSlow:(QPLiveSession *)session {
    
    NSLog(@"网络太差");
}

- (void)liveSessionConnectSuccess:(QPLiveSession *)session {
    
    NSLog(@"connect success!");
}

- (void)openAudioSuccess:(QPLiveSession *)session {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self alertController:@"麦克风打开成功" message:nil leftTitle:nil rightTitle:@"确定"];
    });
}

- (void)openVideoSuccess:(QPLiveSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self alertController:@"摄像头打开成功" message:nil leftTitle:nil rightTitle:@"确定"];
    });
}


- (void)liveSession:(QPLiveSession *)session openAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self alertController:@"麦克风获取失败" message:nil leftTitle:nil rightTitle:@"确定"];
    });
}

- (void)liveSession:(QPLiveSession *)session openVideoError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
//        [self alertController:@"摄像头获取失败" message:nil leftTitle:nil rightTitle:@"确定"];

    });
}

- (void)liveSession:(QPLiveSession *)session encodeAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self alertController:@"音频编码初始化失败" message:nil leftTitle:nil rightTitle:@"确定"];

    });
    
}

- (void)liveSession:(QPLiveSession *)session encodeVideoError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [self alertController:@"视屏编码初始化失败" message:nil leftTitle:nil rightTitle:@"确定"];
    });
}

#pragma mark ------------  不直播了调用的返回方法  -----------
- (void)dissmissAction {
    
    [self.backView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark ------------  创建子视图  -----------
- (void)createSubViews {
    
    /** 透明背景 */
    self.backView = [[UIView alloc] init];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    /** 地理标志 */
    self.imageViewOfLocation = [[UIImageView alloc] init];
    [self.backView addSubview:_imageViewOfLocation];
    self.imageViewOfLocation.image = [UIImage imageNamed:@"live_location"];
    [_imageViewOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backView.mas_left).mas_equalTo(20);
        make.top.equalTo(self.backView.mas_top).mas_equalTo(80);
    }];
    
    /** 地理名称 */
    self.labelOfLocation = [[UILabel alloc] init];
    [self.backView addSubview:_labelOfLocation];
    [_labelOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imageViewOfLocation.mas_right).mas_offset(10);
        make.centerY.equalTo(self.imageViewOfLocation.mas_centerY);
    }];
    self.labelOfLocation.textColor = [UIColor whiteColor];
    self.labelOfLocation.text = @"不显示地理位置";
    
    /** 位置开关 */
    self.switchOfLocation = [[UISwitch alloc] init];
    [self.backView addSubview:_switchOfLocation];
    [self.switchOfLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backView.mas_right).offset(-20);
        make.centerY.equalTo(self.imageViewOfLocation.mas_centerY);
    }];
    [self.switchOfLocation addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventValueChanged];
    self.switchOfLocation.onTintColor = kSystemColor;
    //    [self.switchOfLocation setOn:YES];
    
    /** 直播标题的textFiled */
    self.textFiledOfTitle = [[UITextField alloc] init];
    [self.backView addSubview:_textFiledOfTitle];
    [_textFiledOfTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.backView.mas_width).multipliedBy(0.7);
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.imageViewOfLocation.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    self.textFiledOfTitle.placeholder = @"起个直播标题, 快来秀!";
    self.textFiledOfTitle.textColor = [UIColor whiteColor];
    self.textFiledOfTitle.font = [UIFont systemFontOfSize:22];
    
    /** 开始直播按钮 */
    self.buttonOfStartLive = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backView addSubview:self.buttonOfStartLive];
    [self.buttonOfStartLive mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.backView.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.textFiledOfTitle.mas_bottom).offset(50);
    }];
    [self.buttonOfStartLive setTitle:@"开始直播" forState:UIControlStateNormal];
    self.buttonOfStartLive.backgroundColor = kSystemColor;
    [self.buttonOfStartLive setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonOfStartLive addTarget:self action:@selector(startLiveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view layoutIfNeeded];
    self.buttonOfStartLive.layer.masksToBounds = YES;
    self.buttonOfStartLive.layer.cornerRadius = self.buttonOfStartLive.bounds.size.height / 2;
    
}

- (void)locationAction:(UISwitch *)sender {
    
    if (sender.isOn) {
        
        if (_isAllowLocation) {
            
            /** 如果刚开始登陆就允许了, 那儿直接就获取到了位置然后把值存起来在这儿直接取就行(默认显示) */
            [self locate];
        }
        
    } else {
        
        self.labelOfLocation.text = @"不显示地理位置";
    }
}

#pragma mark ------------  判断定位功能是否打开  -----------
- (void)locate {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _currentCity = [NSString string];
        [_locationManager startUpdatingLocation];
    }
}


#pragma mark ------------  定位失败的代理方法  -----------
/** 定位失败弹出的提示框, 点击打开定位按钮, 打开系统的定位设置, 提示打开定位 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请打开定位" message:@"请在定位中大开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        NSDictionary *dic = nil;
        [[UIApplication sharedApplication] openURL:settingURL options:dic completionHandler:^(BOOL success) {
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:ok];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

#pragma mark ------------  定位成功的代理方法  -----------
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    // 反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count > 0) {
            
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                
                _currentCity = @"无法定位当前城市";
            }
            // 当前的城市
            _labelOfLocation.text = _currentCity;
            // 具体地址 placeMark.name
        } else if (error == nil && placemarks.count == 0) {
            
            NSLog(@"No location and error")
        } else if (error) {
            
            NSLog(@"location error : %@", error);
        }
    }];
}

#pragma mark ------------  开始直播的方法  -----------
- (void)startLiveAction {

    [self.backView removeFromSuperview];

//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    AVObject *todo = [AVObject objectWithClassName:@"_User" objectId:[AVUser currentUser].objectId];
    
    [todo setObject:self.pullUrl forKey:@"stream_addr"];
    // 保存到云端
    [todo saveInBackground];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleData" object:nil userInfo:nil];
    
    [self createLiveView];
}
- (void)createLiveView {

    self.liveView = [[WH_liveView alloc] initWithFrame:SCREEN_RECT withVCType:Live];
    [self.view addSubview:self.liveView];
    self.liveView.backgroundColor = [UIColor clearColor];
    __weak WH_PersonViewController *weakSelf = self;
    self.liveView.buttonAction = ^(UIButton *btn) {
    
        if (btn.tag == 999) {
            
            
            [weakSelf changeCamera:btn];
        } else if (btn.tag == 888) {
        
            [weakSelf btnOfBackAction];
        } else if (btn.tag == 777) {
        
            [weakSelf seletedMusic];
        }
        
    };
}
#pragma mark ------------  返回 停止直播的方法  -----------
- (void)btnOfBackAction {

    [self destorySession];
    [self.liveView removeFromSuperview];
    
    WH_LiveViewController *liveVC = [[WH_LiveViewController alloc] initWithNibName:@"WH_LiveViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:liveVC animated:NO];
}
#pragma mark ------------  改变摄像头的方法  -----------
- (void)changeCamera:(UIButton *)btn {

    btn.selected = !btn.isSelected;
    _liveSession.devicePosition = btn.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = _liveSession.devicePosition;
}
#pragma mark ------------  选择音乐事件  -----------
- (void)seletedMusic {

    [MobClick event:@"SearchAction"];
    
    WH_SeletedMusicViewController *seletedMusicVC = [WH_SeletedMusicViewController new];
    [self.navigationController pushViewController:seletedMusicVC animated:YES];
    
}


#pragma mark ------------  alert的弹出方法  -----------
- (void)alertController:(NSString *)title message:(NSString *)message leftTitle:(nullable NSString *)leftTitle rightTitle:(nonnull NSString *)rightTitle {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *left = [UIAlertAction actionWithTitle:leftTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:rightTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    if (leftTitle && right) {
        
        [alert addAction:left];
        [alert addAction:right];
    }
    if (!leftTitle) {
        
        [alert addAction:right];
        
    }
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

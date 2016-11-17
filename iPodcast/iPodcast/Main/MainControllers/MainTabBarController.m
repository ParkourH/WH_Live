//
//  MainTabBarController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "MainTabBarController.h"
#import "ListViewController.h"
#import "LiveViewController.h"
#import "MineViewController.h"
#import "MainNavigationController.h"
#import "UIImage+Buffer.h"
#import "UIView+Frame.h"
#import "WH_LiveTypeView.h"
#import "WH_GameViewController.h"
#import "WH_PersonViewController.h"
#import "LoginAlertController.h"
#import "JYJ_LoginViewController.h"
#import <QPLive/QPLive.h>
#import "Masonry.h"
@interface MainTabBarController () <WH_liveViewDelegate, LoginAlertDelegate>

@property (nonatomic, strong) UIButton *liveBtn;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.backgroundColor = [UIColor blackColor];
    /** 添加所有的子控制器 */
    [self setupAllViewController];
    
    /** tabBar上按钮的内容 */
    [self setupAllTabBarButton];
    
    /** 添加采集视频按钮 */
    [self addLivebutton];
   
}
#pragma mark ------------  添加所有子控件  -----------
- (void)setupAllViewController {

    // 第一个ListViewController
    ListViewController *listVC = [[ListViewController alloc] init];
    MainNavigationController *listNavi = [[MainNavigationController alloc] initWithRootViewController:listVC];
    
    [self addChildViewController:listNavi];
    
    // 第二个LiveViewController
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    MainNavigationController *liveNavi = [[MainNavigationController alloc] initWithRootViewController:liveVC];
    
    [self addChildViewController:liveNavi];
    
    // 第三个MineViewController
    MineViewController *mineVC = [[MineViewController alloc] init];
    MainNavigationController *mineNavi = [[MainNavigationController alloc] initWithRootViewController:mineVC];
    
    [self addChildViewController:mineNavi];
}

#pragma mark ------------  设置按钮的内容  -----------
- (void)setupAllTabBarButton {

    ListViewController *listVC = self.childViewControllers[0];
    listVC.tabBarItem.image = [UIImage imageNamed:@"tab_list"];
    listVC.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:@"tab_list_seleted"];
    
    LiveViewController *liveVC = self.childViewControllers[1];
    liveVC.tabBarItem.enabled = NO;
    
    MineViewController *mineVC = self.childViewControllers[2];
    
    mineVC.tabBarItem.image = [UIImage imageNamed:@"tab_mine"];
    mineVC.tabBarItem.selectedImage = [UIImage imageWithOriginalRenderingMode:@"tab_mine_seleted"];
    
    // 调整TabBarItem位置
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 0, -5, 0);
    UIEdgeInsets liveInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    listVC.tabBarItem.imageInsets = insets;
    mineVC.tabBarItem.imageInsets = insets;
    liveVC.tabBarItem.imageInsets = liveInsets;
    
    // 隐藏阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
}

#pragma mark ------------  添加采集视屏按钮  -----------
- (void)addLivebutton {

    self.liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBar addSubview:_liveBtn];
    
    _liveBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _liveBtn.layer.shadowOffset = CGSizeMake(3, 5);
    _liveBtn.layer.shadowRadius = 3;
    _liveBtn.layer.shadowOpacity = 0.8;
 
    _liveBtn.backgroundColor = [UIColor whiteColor];
    [_liveBtn setImage:[UIImage imageNamed:@"tab_live"] forState:UIControlStateNormal];
    [_liveBtn setImage:[UIImage imageNamed:@"tab_live_seleted"] forState:UIControlStateHighlighted];
    // 自适应, 自动根据按钮图片和文字计算按钮尺寸
    [_liveBtn addTarget:self action:@selector(liveAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ------------  点击直播的事件  -----------
- (void)liveAction:(UIButton *)sender {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {

        WH_LiveTypeView *liveTypeView = [[WH_LiveTypeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        liveTypeView.delegate = self;
        [liveTypeView show];
    } else {
    
        [self gotoLogin];
    }
}

- (void)gotoLogin {

    LoginAlertController *loginAlert = [LoginAlertController alertControllerWithTitle:@"温馨提示" message:@"登录后再来直播吧" preferredStyle:UIAlertControllerStyleAlert];
    loginAlert.delegate = self;
    [self presentViewController:loginAlert animated:YES completion:^{
        
    }];

}
#pragma mark ----代理 登录
- (void)clickConfirmButton:(LoginAlertController *)alert {
    JYJ_LoginViewController *login = [[JYJ_LoginViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    self.tabBar.hidden = YES;
    // 获取mainNavi [self.viewControllers firstObject]
    // 然后获取他的子视图 取出栈中的第一个VC（也就是首页的VC）
    if (self.selectedIndex == 0) {
        
        
    [[[self.viewControllers firstObject].childViewControllers firstObject].navigationController pushViewController:login animated:YES];
    } else if (self.selectedIndex == 2) {
    
    [[[self.viewControllers lastObject].childViewControllers firstObject].navigationController pushViewController:login animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)didSelectBtnWithBtnTag:(NSInteger)tag {
    
    if (tag == 100) {
        
        NSLog(@"游戏");
        WH_GameViewController *gameVC = [[WH_GameViewController alloc] init];
        UINavigationController *gameNavi = [[UINavigationController alloc] initWithRootViewController:gameVC];
        
        [self presentViewController:gameNavi animated:NO completion:^{
            
        }];
    } else if (tag == 200) {
        
        NSLog(@"真人秀");
        [self createActivityIndicator];
        
        QPLiveRequest *request = [[QPLiveRequest alloc] init];
        [request requestCreateLiveWithDomain:@"http://spacename250039415.s.qupai.me" success:^(NSString *pushUrl, NSString *pullUrl) {
            
            
            [self.activityIndicator stopAnimating];
            if (pushUrl) {
        
                WH_PersonViewController *personVC = [[WH_PersonViewController alloc] init];
                UINavigationController *personNavi = [[UINavigationController alloc] initWithRootViewController:personVC];
                personVC.url = pushUrl;
                /** 保存拉流网址 */
                personVC.pullUrl = pullUrl;
                
                
                
                [self presentViewController:personNavi animated:NO completion:^{
                    
                    
                }];
            } else {
                
                NSLog(@"111");
            }
        } failure:^(NSError *error) {
            [self.activityIndicator stopAnimating];
            NSLog(@"create live failed %@", error);
        }];
//
       
    }
}

#pragma mark ------------  创建ActivityIndicator  -----------
- (void)createActivityIndicator {

    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.view addSubview:_activityIndicator];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.view);
        make.width.height.mas_equalTo(50);
    }];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityIndicator startAnimating];
}


#pragma mark ------------  自定义TabBar高度  -----------
- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
    
    _liveBtn.frame = CGRectMake(0, 0, 60, 60);
    _liveBtn.center = CGPointMake(self.tabBar.wh_width * 0.5, 10);
    _liveBtn.layer.masksToBounds = YES;
    _liveBtn.layer.cornerRadius = 30;
    
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 50;
    tabFrame.origin.y = self.view.frame.size.height - 50;
    self.tabBar.frame = tabFrame;
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

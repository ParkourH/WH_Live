//
//  JYJ_SetViewController.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_SetViewController.h"
#import "Ipodcast.h"
#import "JYJ_SetTableViewCell.h"
#import "Masonry.h"
#import "JYJ_LoginViewController.h"
#import "ListViewController.h"
#import "AppDelegate.h"
#import "Ipodcast.h"
@interface JYJ_SetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *marrOfFirst;
@property (nonatomic, strong) NSMutableArray *marrOfThird;
@end

@implementation JYJ_SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.marrOfFirst = [NSMutableArray arrayWithObjects:@"黑名单",@"开播提醒", nil];
    self.marrOfThird = [NSMutableArray arrayWithObjects:@"帮助与反馈",@"关于我们",@"网络诊断", nil];
    self.navigationController.navigationBar.barTintColor = kSystemColor;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self createTableView];

    // Do any additional setup after loading the view.
}
// 退出登录
- (void)createButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableView.tableFooterView addSubview:backButton];
    [backButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [backButton setTitleColor:kSystemColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.tableFooterView.mas_centerX);
        make.centerY.equalTo(self.tableView.tableFooterView.mas_centerY);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH * 3 /4);
    }];
    [backButton layoutIfNeeded];
    backButton.layer.cornerRadius = backButton.bounds.size.height / 2;
    backButton.layer.borderColor = kSystemColor.CGColor;
    backButton.layer.borderWidth = 2;
    backButton.backgroundColor = [UIColor whiteColor];
}
#pragma mark -------退出登录
- (void)handleBack {
   // 跳回首页
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"userName"];
    [user removeObjectForKey:@"passWord"];
    [user removeObjectForKey:@"userId"];
    [user removeObjectForKey:@"image"];
    [user removeObjectForKey:@"objectId"];
    AVUser *user1 = [AVUser user];
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ]) {
        [user1 deleteAuthDataForPlatform:AVOSCloudSNSPlatformQQ block:^(AVUser *user, NSError *error) {
            if (error) {
                // 解除失败，多数为网络问题
            } else {
                // 解除成功
            }
        }];
        
    }
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSSinaWeibo]) {
        [user1 deleteAuthDataForPlatform:AVOSCloudSNSPlatformWeiBo block:^(AVUser *user, NSError *error) {
            if (error) {
                // 解除失败，多数为网络问题
            } else {
                // 解除成功
            }
            
        }];
        
    }
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSWeiXin]) {
        [user1 deleteAuthDataForPlatform:AVOSCloudSNSPlatformWeiXin block:^(AVUser *user, NSError *error) {
            if (error) {
                // 解除失败，多数为网络问题
            } else {
                // 解除成功
            }
            
        }];
        
    }

    [self.tabBarController setSelectedIndex:0];
    
    [self.navigationController popViewControllerAnimated:YES];
   
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JYJ_SetTableViewCell class] forCellReuseIdentifier:@"pool"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 100);
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footView;
   [self createButton];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else if (section == 2) {
        return 1;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYJ_SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
    if (indexPath.section == 0 ) {
        cell.setTitleLabel.text = @"账号与安全";
    }else if (indexPath.section == 1) {
        cell.setTitleLabel.text = self.marrOfFirst[indexPath.row];
    }else if (indexPath.section == 2) {
        cell.setTitleLabel.text = @"清除缓存";
    }else {
        cell.setTitleLabel.text = self.marrOfThird[indexPath.row];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
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

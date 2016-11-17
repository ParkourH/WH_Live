//
//  MineViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "MineViewController.h"
#import "Ipodcast.h"
#import "JYJ_HeadTableView.h"
#import "Masonry.h"
#import "JYJ_SectionView.h"
#import "JYJ_MineTableViewCell.h"
#import "JYJ_EditViewController.h"
#import "JYJ_SetViewController.h"
#import "JYJ_AttentionViewContoller.h"
#import "LoginAlertController.h"
#import "JYJ_LoginViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,LoginAlertDelegate>
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JYJ_HeadTableView *headView;
@property (nonatomic, strong)   NSMutableArray *titleMarr ;
@property (nonatomic, strong)  NSMutableArray *marr ;
@property (nonatomic, strong) UIImage *fileImage;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleMarr = [NSMutableArray arrayWithObjects:@"播客贡献榜",@"收益",@"账户", nil];
   self.marr = [NSMutableArray arrayWithObjects:@"",@"0 播票",@"0 钻石",nil];

    self.backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_image"]];
    [self.view addSubview:_backImage];
    self.backImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    self.navigationController.navigationBar.hidden = YES;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:searchButton];
    [searchButton setImage:[UIImage imageNamed:@"navi_search"] forState:UIControlStateNormal];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:messageButton];
    [messageButton setImage:[UIImage imageNamed:@"navi_message"] forState:UIControlStateNormal];
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    [self createTableView];

    [self createHeadView];
}
- (void)createHeadView {
    self.headView = [[JYJ_HeadTableView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.tableView.tableHeaderView = self.headView;
       self.headView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.98 alpha:1.00];
    [self.tableView registerClass:[JYJ_MineTableViewCell class] forCellReuseIdentifier:@"pool"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[JYJ_SectionView class] forHeaderFooterViewReuseIdentifier:@"firstSection"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   JYJ_MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.titleLabel.text = _titleMarr[indexPath.row];
        cell.rightLabel.text = _marr[indexPath.row ];
        cell.rightLabel.textColor = [UIColor colorWithRed:0.99 green:0.62 blue:0.36 alpha:1.00];
        
    }
    else if (indexPath.section == 1){
        cell.titleLabel.text = @"等级";
        cell.rightLabel.text = @"1 等级";
        cell.rightLabel.textColor = [UIColor colorWithRed:0.76 green:0.78 blue:0.77 alpha:1.00];
    }else {
        cell.titleLabel.text = @"设置";
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return   60;
}
// 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        JYJ_SectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"firstSection"];
        [sectionView live:^(UIButton *button) {
            NSLog(@"直播");
        } attention:^(UIButton *button) {
            JYJ_AttentionViewContoller *attention = [[JYJ_AttentionViewContoller alloc]init];
            self.tabBarController.tabBar.hidden = YES;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:attention animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } fan:^(UIButton *button) {
            NSLog(@"粉丝");
        }];
        return sectionView;
    }
    return nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y < 0) {
        CGFloat addHeight = - offsetY;
        CGFloat scale = (addHeight + 300) / 300;
        self.backImage.frame = CGRectMake(-(SCREEN_WIDTH * scale - SCREEN_WIDTH) / 2, 0, SCREEN_WIDTH * scale, 300  + addHeight);
    }
    CGFloat sectionHearderHeight = 60;
    if (offsetY >=0 && offsetY <= sectionHearderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
    }else if (offsetY >= sectionHearderHeight && offsetY <= scrollView.contentSize.height - scrollView.frame.size.height){
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHearderHeight, 0, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      NSString *name = [user objectForKey:@"userName"];
        if (name == nil) {
            [self gotoLogin];
        }else {
            JYJ_SetViewController *set = [[JYJ_SetViewController alloc]init];
            self.hidesBottomBarWhenPushed = YES;
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:set animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"userName"];
    NSNumber *num = [userDefaults objectForKey:@"userId"];
   // NSData *data = [userDefaults objectForKey:@"image"];
   
    //NSLog(@"%@",data);
    if (name == nil) {
        self.headView.nameLabel.text = @"昵称:您还没有登录";
        self.headView.logoLabel.text = @"博客号:您还没有登录";
        self.headView.headImageView.image = [UIImage imageNamed:@"head_zhanwei"];
        
    }else {
        self.headView.nameLabel.text = [NSString stringWithFormat:@"昵称:%@",name];
        self.headView.logoLabel.text = [NSString stringWithFormat:@"播客号:%@",num];
        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
        [query getObjectInBackgroundWithId:[AVUser currentUser].objectId block:^(AVObject *object, NSError *error) {
            NSLog(@"%@",object[@"file"]);
            AVFile *file = (AVFile *)object[@"file"];
            NSLog(@"%@",file.name);
//            NSData *imageNewData = [NSData dataWithContentsOfFile:file.name];
//            self.fileImage = [UIImage imageWithData:imageNewData];
//            self.headView.headImageView.image = _fileImage;
            [self.headView.headImageView sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageNamed:@"head_zhanwei"]];
            
        }];      
       

    }
   
    
}
- (void)gotoLogin {
    
    LoginAlertController *loginAlert = [LoginAlertController alertControllerWithTitle:@"温馨提示" message:@"登录后再来设置吧！" preferredStyle:UIAlertControllerStyleAlert];
    loginAlert.delegate = self;
    [self presentViewController:loginAlert animated:YES completion:^{
        
    }];
    
}
- (void)clickConfirmButton:(LoginAlertController *)alert {
    JYJ_LoginViewController *login = [[JYJ_LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
 
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

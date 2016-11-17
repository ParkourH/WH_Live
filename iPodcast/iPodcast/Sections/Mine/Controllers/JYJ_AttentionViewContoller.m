//
//  JYJ_AttentionViewContoller.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_AttentionViewContoller.h"
#import "Ipodcast.h"
#import "JYJ_AttentionTableViewCell.h"
@interface JYJ_AttentionViewContoller ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JYJ_AttentionViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kSystemColor;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"关注的人";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(handleAdd)];
    [self createTableView];
    // Do any additional setup after loading the view.
}
- (void)handleAdd {
    NSLog(@"add");
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 10) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.tableView registerClass:[JYJ_AttentionTableViewCell class] forCellReuseIdentifier:@"pool"];
    self.tableView.showsVerticalScrollIndicator = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYJ_AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewScrollPositionNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYJ_AttentionTableViewCell *cell = (JYJ_AttentionTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.cancleImage.hidden = YES;
    cell.plusImage.hidden = NO;
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

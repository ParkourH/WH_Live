//
//  WH_SeletedMusicViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_SeletedMusicViewController.h"
#import "Ipodcast.h"
#import "WH_SearchTableViewController.h"
#import "WH_SearchMusicCell.h"
#import "WH_MusicModel.h"
@interface WH_SeletedMusicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<WH_Track *> *mArr;

@property (nonatomic, copy) NSString *musicPath;
@end

@implementation WH_SeletedMusicViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = kSystemColor;
    [self handleData];

}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavi];
    [self createTableView];
}
- (void)handleData {

    self.mArr = [NSMutableArray array];
    self.musicPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"loadPath"] stringByAppendingPathComponent:@"model.plist"];
    self.mArr = [[NSKeyedUnarchiver unarchiveObjectWithFile:_musicPath] mutableCopy];
    [self.tableView reloadData];
}


- (void)createNavi {

    UIButton *buttonOfsearch = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonOfsearch.frame = CGRectMake(15, 5, SCREEN_WIDTH * 0.7, 34);
    buttonOfsearch.backgroundColor = [UIColor colorWithRed:0.00 green:0.90 blue:0.7 alpha:1.00];
    [buttonOfsearch layoutIfNeeded];
    buttonOfsearch.layer.masksToBounds = YES;
    buttonOfsearch.layer.cornerRadius = buttonOfsearch.bounds.size.height / 2;
    [buttonOfsearch setTitle:@"搜索歌曲" forState:UIControlStateNormal];
    [buttonOfsearch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buttonOfsearch setImage:[UIImage imageNamed:@"navi_search"] forState:UIControlStateNormal];
    [buttonOfsearch setImageEdgeInsets:UIEdgeInsetsMake(0, -buttonOfsearch.bounds.size.width / 2, 0, 0)];
    [buttonOfsearch setTitleEdgeInsets:UIEdgeInsetsMake(0, -buttonOfsearch.bounds.size.width / 2 + 10, 0, 0)];
    [buttonOfsearch addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonOfsearch];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:mDic forState:UIControlStateNormal];
}

- (void)createTableView {

    self.tableView = [[UITableView alloc] initWithFrame:SCREEN_RECT style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_SearchMusicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pool"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.mArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_SearchMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool"];
   
    cell.modelOfTrack = self.mArr[indexPath.row];
    
    cell.playMusic.hidden = NO;
    cell.loadMusic.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}

- (void)searchAction {

    WH_SearchTableViewController *searchTableViewVC = [[WH_SearchTableViewController alloc] init];
    [self.navigationController pushViewController:searchTableViewVC animated:YES];
}

#pragma mark ------------  编辑  -----------
/** 滑动删除 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_Track *model = self.mArr[indexPath.row];
    
    [self.mArr removeObject:model];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    BOOL isModelWriteSuccess = [NSKeyedArchiver archiveRootObject:_mArr toFile:_musicPath];
    if (isModelWriteSuccess) {
        
        NSLog(@"音乐对应的Model删除成功");
        
    } else {
        
        NSLog(@"音乐对应的Model删除失败");
    }

//    NSString *delegatePath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"loadPath"] stringByAppendingPathComponent:@"model.plist"];
//    NSError *error = nil;
//    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:delegatePath error:&error];
//    if (isSuccess) {
//        
//        NSLog(@"音乐删除成功");
//        [self.mArr removeObject:model];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        NSString *path = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)   lastObject] stringByAppendingPathComponent:@"loadPath"] stringByAppendingPathComponent:@"model.plist"];
//        
//        BOOL isModelWriteSuccess = [NSKeyedArchiver archiveRootObject:_mArrOfMusic toFile:path];
//        if (isModelWriteSuccess) {
//            
//            NSLog(@"音乐对应的Model删除成功");
//            [self showAlert:@"删除成功"];
//        } else {
//            
//            NSLog(@"音乐对应的Model删除失败");
//        }
//    } else {
//        
//        NSLog(@"音乐删除失败");
//    }
}


#pragma mark ------------  返回  -----------
- (void)cancleAction {

    [self.navigationController popViewControllerAnimated:YES];
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

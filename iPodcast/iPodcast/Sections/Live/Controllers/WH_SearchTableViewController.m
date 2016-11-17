//
//  WH_SearchTableViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_SearchTableViewController.h"
#import "Ipodcast.h"
#import "WH_MusicModel.h"
#import "WH_SearchMusicCell.h"
#import "WH_MusicManager.h"

@interface WH_SearchTableViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) WH_MusicModel *model;

@property (nonatomic, strong) NSMutableArray *mArr;

@end

@implementation WH_SearchTableViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self createNaviSearch];
  
    /** 注册 */
    [self.tableView registerNib:[UINib nibWithNibName:@"WH_SearchMusicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"pool"];
}

- (void)createNaviSearch {

    /** 左边搜索 */
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 100, 44)];
    _searchBar.placeholder = @"搜索歌曲";
    _searchBar.delegate = self;
    [_searchBar becomeFirstResponder];
//    [searchBar layoutIfNeeded];
//    searchBar.layer.masksToBounds = YES;
//    searchBar.layer.cornerRadius = searchBar.bounds.size.height / 2;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    /** 右边取消 */
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    // 字体颜色
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    mDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:mDic forState:UIControlStateNormal];
}
#pragma mark ------------  取消返回的方法  -----------
- (void)cancleAction {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self handleData];
}
#pragma mark ------------  写搜索的方法  -----------
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [self handleData];
}


- (void)handleData {

    /** 获取searchBar上的字 */
    NSString *strOfSearch = [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    /** 获取当前时间 */
    NSDate *date = [NSDate date];
    NSString *strOfTime = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    
    NSString *string = [NSString stringWithFormat:@"http://116.211.167.106/api/accompany/search?lc=0000000000000039&cc=TG0001&cv=IK3.6.10_Iphone&proto=7&idfa=B9743514-1702-460C-9E74-917CC880457A&idfv=675DDC6F-1592-41F4-BA82-6F5317C3513B&devi=ddf84b37ceb43f2164ba1d0d3e823e7e5d43ba50&osversion=ios_10.000000&ua=iPad4_4&imei=&imsi=&uid=250257389&sid=20ffAYGvaafKysxIe801lwYGsFnzN4CsNq0X4F4zEcIxG89luD&conn=wifi&mtid=a1e79cece4c6b996ea01b7d86d01b994&mtxid=d468ba815515&logid=&start=0&count=15&keyword=%@&s_sg=497fc156cde410b8230a2f9f1353c241&s_sc=100&s_st=%@", strOfSearch, strOfTime];
    
   [ZWYNetTool GET:string andBody:nil andHeader:nil andResponse:ZWYJSON andSuccessBlock:^(id result) {
      
       self.model = [WH_MusicModel mj_objectWithKeyValues:result];
       [self.tableView reloadData];
   } andFailureBlock:^(NSError *error) {
       NSLog(@"%@", error);
   }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.model.results.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WH_SearchMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pool" forIndexPath:indexPath];
    
    WH_Track *model = self.model.results[indexPath.row].track;
    /** 先判断是否已下载 */
    self.mArr = [NSMutableArray array];
    NSString *musicPath = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"loadPath"] stringByAppendingPathComponent:@"model.plist"];
    self.mArr = [[NSKeyedUnarchiver unarchiveObjectWithFile:musicPath] mutableCopy];
    for (WH_Track *track in self.mArr) {
        
        if (track.WH_ID == model.WH_ID) {
            
            cell.loadMusic.hidden = YES;
            cell.playMusic.hidden = NO;

        } else {
        
            cell.loadMusic.hidden = NO;
            cell.playMusic.hidden = YES;
        }
    }
//    if ([self.mArr containsObject:model]) {
//        
//        cell.loadMusic.hidden = YES;
//        cell.playMusic.hidden = NO;
//    } else {
//    
//        cell.loadMusic.hidden = NO;
//        cell.playMusic.hidden = YES;
//    }
    
    cell.modelOfTrack = model;
    
    model.onProgressChanged = ^(WH_Track *changeModel) {
    
        cell.progressView.progress = changeModel.progress;
        NSInteger progress = [[NSString stringWithFormat:@"%f", changeModel.progress * 100] integerValue];
        
        cell.loadProgress.text = [NSString stringWithFormat:@"%ld/100", progress];
    };
    
    model.onStatusChanged = ^ (WH_Track *changeModel) {
    
        if (changeModel.status == kWHMusicStatusCompleted) {
            
            cell.progressView.hidden = YES;
            cell.playMusic.hidden = NO;
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    WH_SearchMusicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.playMusic.hidden) {
        
        cell.loadMusic.image = [UIImage new];
        cell.progressView.hidden = NO;
        [self loadModel:cell.modelOfTrack];
        [MobClick event:@"CalculationAction" attributes:@{@"歌曲" : @"喜欢你"}];
    }
    
}


- (void)loadModel:(WH_Track *)model {
    
    NSLog(@"loading");
    switch (model.status) {
        case kWHMusicStatusNone: {
            [[WH_MusicManager sharedManager] startWithMusicModel:model];
            NSLog(@"正在下载");
            break;
        }
        case kWHMusicStatusRunning: {
            [[WH_MusicManager sharedManager] suspendWithMusicModel:model];
            NSLog(@"已经加入下载列表");
            break;
        }
        case kWHMusicStatusSuspended: {
            [[WH_MusicManager sharedManager] resumeWithMusicModel:model];
            break;
        }
        case kWHMusicStatusCompleted: {
            
            NSLog(@"已经下载");
            
            break;
        }
        case kWHMusicStatusFailed: {
            [[WH_MusicManager sharedManager] resumeWithMusicModel:model];
            NSLog(@"暂停下载");
            break;
        }
        case kWHMusicStatusWaiting: {
            [[WH_MusicManager sharedManager] startWithMusicModel:model];
            NSLog(@"等待下载");
            break;
        }
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

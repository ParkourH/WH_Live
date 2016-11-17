//
//  ListViewController.m
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
#import "ZWYNetTool.h"
#import "Masonry.h"
#import "ListViewController.h"
#import "Ipodcast.h"
#import "XK_Button.h"
#import "XK_HotCollectionViewCell.h"
#import "XK_NearbyCollectionViewCell.h"
#import "XK_ListView.h"
#import "LivesModel.h"
#import "WH_PlayerViewController.h"

@interface ListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray<LivesModel *> *_listData;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *hotButton;
@property (nonatomic, strong) UIButton *nearbyButton;
@property (nonatomic, strong) UIButton *attentionButton;



@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kSystemColor;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_message"] style:UIBarButtonItemStylePlain target:self action:@selector(goChat:)];
    [self createCollectionView];
    [self createTitleButton];
    
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew || NSKeyValueChangeOldKey context:nil];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAction:) name:@"handleData" object:nil];
}

- (void)handleAction:(NSNotification *) info{

    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[AVUser currentUser].objectId block:^(AVObject *object, NSError *error) {
        NSLog(@"%@",[object objectForKey:@"stream_addr"]);
        LivesModel *modelOfIpodcast = [LivesModel mj_objectWithKeyValues:object];
        [_listData addObject:modelOfIpodcast];
        [self.collectionView reloadData];
    }];
}

- (void)initData{
    _listData = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getListDate];
//        [self handleData];
    });
}

- (void)getListDate{
  
    
    
   
    [ZWYNetTool GET:@"http://101.200.29.199/api/live/simpleall?cc=TG0001&conn=Wifi&cv=IK2.5.10_Iphone&devi=44d94653f9a0934cc94f12e542d7d363fae4256b&idfa=07506DA9-419B-460D-BAC8-E035DD6099BC&idfv=3D5EC291-4DDF-44FE-8AC7-B9598B532319&imei=&imsi=&lc=0000000000000014&multiaddr=1&osversion=ios_9.200000&proto=1&sid=EE3qPwpb4VuMR65ShMqfaS8i3&ua=iPhone%205s&uid=509195" andBody:nil andHeader:nil andResponse:ZWYJSON andSuccessBlock:^(id result) {
        NSLog(@"~~~~~~~~~~~~~~~~~~~%@",result);
        NSMutableArray *dataDic = [result objectForKey:@"lives"];
        
        for (int i=0; i<dataDic.count; i++) {
            LivesModel *model=[LivesModel mj_objectWithKeyValues:dataDic[i]];
            [_listData addObject:model];
            
        }
        
        
        [self.collectionView reloadData];

    } andFailureBlock:^(NSError *error) {
        
    }];
}
- (void)goChat:(UIBarButtonItem *)rightBarButtonItem{
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.collectionView.contentOffset.x == 0) {
            self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
            self.nearbyButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }else if (self.collectionView.contentOffset.x == SCREEN_WIDTH){
            self.hotButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:17];
            self.nearbyButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }else if(self.collectionView.contentOffset.x == SCREEN_WIDTH * 2){
            self.nearbyButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:17];
            self.hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
        }else{
            
        }
    }
}
- (void)createTitleButton{
   
    self.hotButton = [[XK_Button alloc]initWithFrame:CGRectMake(44+(SCREEN_WIDTH-88)/3, 0, (SCREEN_WIDTH-88)/3, 44) title:@"热门" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17]];
    [self.navigationController.navigationBar addSubview:self.hotButton];
    self.attentionButton = [[XK_Button alloc]initWithFrame:CGRectMake(44, 0, (SCREEN_WIDTH-88)/3, 44)  title:@"关注" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17]];
    [self.navigationController.navigationBar addSubview:self.attentionButton];
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_downMore"]];
    image.frame = CGRectMake(34+(SCREEN_WIDTH-88) / 3 + (SCREEN_WIDTH-88)/ 6  ,30, 20, 10);
    [self.navigationController.navigationBar addSubview:image];
    
    self.nearbyButton = [[XK_Button alloc]initWithFrame:CGRectMake(44+(SCREEN_WIDTH-88)/3 * 2, 0, (SCREEN_WIDTH-88)/3, 44) title:@"附近" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:17]];
    [self.navigationController.navigationBar addSubview:self.nearbyButton];
    
    [self.hotButton addTarget:self action:@selector(goHot:) forControlEvents:UIControlEventTouchUpInside];
    [self.nearbyButton addTarget:self action:@selector(goNearby:) forControlEvents:UIControlEventTouchUpInside];
    [self.attentionButton addTarget:self action:@selector(goAttention:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)goHot:(UIButton *)button{
    if (self.collectionView.contentOffset.x == SCREEN_WIDTH) {
        
        
            XK_ListView *listView = [[XK_ListView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            
        [listView show];
        
       
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

- (void)goNearby:(UIButton *)button{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
- (void)goAttention:(UIButton *)button{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT-64-49 );
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(-76, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-49) collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[XK_HotCollectionViewCell class] forCellWithReuseIdentifier:@"XK_HotCollectionViewCell"];
    [self.collectionView registerClass:[XK_NearbyCollectionViewCell class] forCellWithReuseIdentifier:@"XK_NearbyCollectionViewCell"];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item == 2) {
        XK_NearbyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XK_NearbyCollectionViewCell" forIndexPath:indexPath];
        cell.livesData = _listData;
        
   
        return cell;
    }else if (indexPath.item == 1){
        XK_HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XK_HotCollectionViewCell" forIndexPath:indexPath];
        
        cell.looklive = ^(NSIndexPath *indexPath) {
        
            [self gotoLookLive:indexPath];
        };
        cell.listData = _listData;
        
        return cell;
    }else{
        XK_HotCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XK_HotCollectionViewCell" forIndexPath:indexPath];
        
        cell.listData = _listData;
        cell.looklive = ^(NSIndexPath *indexPath) {
            
            [self gotoLookLive:indexPath];
        };
        
        return cell;
    }
    

}


#pragma mark ------------  点击去看人家直播  -----------
- (void)gotoLookLive:(NSIndexPath *)indexPath {

    WH_PlayerViewController *playVC = [[WH_PlayerViewController alloc] init];
    playVC.model = _listData[indexPath.row];
    [self.navigationController pushViewController:playVC animated:YES];
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

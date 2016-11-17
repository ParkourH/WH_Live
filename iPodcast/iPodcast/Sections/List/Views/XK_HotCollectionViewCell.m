//
//  XK_HotCollectionViewCell.m
//  iPodcast
//
//  Created by Sober on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
#import "Ipodcast.h"
#import "XK_HotTableViewCell.h"
#import "XK_HotCollectionViewCell.h"
@interface XK_HotCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LivesModel *model;
@end
@implementation XK_HotCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.contentView.bounds;
}
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XK_HotTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XK_HotTableViewCell"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XK_HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XK_HotTableViewCell" forIndexPath:indexPath];
    
    LivesModel *model=_listData[indexPath.row];
    
    [cell setCellDataModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_looklive) {
        
        _looklive(indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64+SCREEN_WIDTH+50;
}
- (void)setListData:(NSArray *)listData{
    _listData = listData;
    [self.tableView reloadData];
}
@end

//
//  XK_ListView.m
//  iPodcast
//
//  Created by Sober on 16/10/22.
//  Copyright © 2016年 ParkourH. All rights reserved.
#import "Ipodcast.h"
#import "XK_ListViewCell.h"
#import "XK_ListView.h"
@interface XK_ListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) UIButton *manButton;
@property (nonatomic, strong) UIButton *womanButton;
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *gameButton;
@property (nonatomic, strong) UIButton *realButton;
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation XK_ListView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [self createWhiteView];
        [self createTableView];
        self.cityArray = @[@"热门",@"北京",@"上海",@"天津",@"重庆",@"香港",@"澳门",@"台湾",@"广东",@"山东",@"江苏",@"河南",@"河北",@"浙江",@"陕西",@"湖南",@"福建",@"云南",@"四川",@"广西",@"安徽",@"海南",@"江西",@"湖北",@"山西",@"辽宁",@"黑龙江",@"内蒙古",@"贵州",@"甘肃",@"吉林",@"其他",@"海外",@"火星"];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).mas_offset(20);
        make.right.equalTo(self.mas_right).mas_offset(-20);
        make.top.equalTo(self.mas_top).mas_offset(100);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-100);
    }];
}
- (void)createWhiteView{
    self.whiteView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_whiteView];
    self.whiteView.layer.cornerRadius = 20;
    self.whiteView.layer.masksToBounds = YES;
    [self createSelectView];
   
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH-40, SCREEN_HEIGHT-370) style:UITableViewStylePlain];
    [self.whiteView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XK_ListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"XK_ListViewCell"];
    
}
- (void)createSelectView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.whiteView addSubview:headView];
    self.allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.allButton];
    [self.allButton setBackgroundImage:[UIImage imageNamed:@"quanbu"] forState:UIControlStateNormal];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView.mas_centerX);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.height.mas_offset((SCREEN_WIDTH-160)/5);
    }];
    
    self.gameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.gameButton];
    [self.gameButton setBackgroundImage:[UIImage imageNamed:@"youxi"] forState:UIControlStateNormal];
    [self.gameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).mas_offset(20);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.height.mas_offset((SCREEN_WIDTH-160)/5);
    }];
    
    self.realButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.realButton];
    [self.realButton setBackgroundImage:[UIImage imageNamed:@"zhen"] forState:UIControlStateNormal];
    [self.realButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gameButton.mas_right).mas_offset(20);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.height.mas_offset((SCREEN_WIDTH-160)/5);
    }];
    
    self.womanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.womanButton];
    [self.womanButton setBackgroundImage:[UIImage imageNamed:@"nv"] forState:UIControlStateNormal];
    [self.womanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allButton.mas_right).mas_offset(20);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.height.mas_offset((SCREEN_WIDTH-160)/5);
    }];
    
    self.manButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.manButton];
    [self.manButton setBackgroundImage:[UIImage imageNamed:@"nan"] forState:UIControlStateNormal];
    [self.manButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.womanButton.mas_right).mas_offset(20);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.height.mas_offset((SCREEN_WIDTH-160)/5);
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XK_ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XK_ListViewCell" forIndexPath:indexPath];
    cell.cityNameLabel.text = self.cityArray[indexPath.row];
    return cell;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

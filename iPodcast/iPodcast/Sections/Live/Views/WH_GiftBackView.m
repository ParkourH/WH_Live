//
//  WH_GiftBackView.m
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_GiftBackView.h"
#import "Ipodcast.h"
#import "WH_GiftCollectionViewCell.h"
#import "WH_GiftModel.h"
@interface WH_GiftBackView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) WH_GiftModel *model;
/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeButton;

@end


@implementation WH_GiftBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self createSubViews];
        
    }
    return self;
}

- (void)createSubViews {

    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[WH_GiftCollectionViewCell class] forCellWithReuseIdentifier:@"pool"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    
    /** 发送礼物按钮 */
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_sendButton];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
        make.width.equalTo(_sendButton.mas_height).multipliedBy(3);
    }];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.backgroundColor = [UIColor grayColor];
    [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _sendButton.tag = 7878;
    /** 充值按钮 */
    self.rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_rechargeButton];
    [_rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.sendButton.mas_centerY);
    }];
    self.rechargeButton.backgroundColor = [UIColor clearColor];
    /** 这里的初值要从服务器读取 */
    [self.rechargeButton setTitle:@"充值:100💎 >" forState:UIControlStateNormal];
    [self.rechargeButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rechargeButton.tag = 1314;
}

- (void)sendButtonAction:(UIButton *)sender {

    
    
    BOOL isEnough = YES;
    if (sender.tag == 7878) {
        
        NSString *string = self.rechargeButton.titleLabel.text;
        string = [[string componentsSeparatedByString:@":"] lastObject];
        string = [[string componentsSeparatedByString:@"💎"] firstObject];
        NSInteger integer = [string integerValue] - _model.giftCost;
        
        if (integer >= 0) {
            
            NSString *str = [NSString stringWithFormat:@"充值:%ld💎 >", integer];
            [self.rechargeButton setTitle:str forState:UIControlStateNormal];
            isEnough = YES;
        } else {
            
            isEnough = NO;
        }

    } else if (sender.tag == 1314) {
    
        isEnough = YES;
    }
    if (self.sendPresent) {
        
        self.sendPresent(sender, _model, isEnough);
    }
}

#pragma mark ------------  代理协议方法  -----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WH_GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pool" forIndexPath:indexPath];
    cell.sendGift = ^(WH_GiftModel *model, UIImageView *imageViewOfSeleted) {
    
        self.model = model;
        if (imageViewOfSeleted.isHidden) {
            
            self.sendButton.backgroundColor = [UIColor grayColor];
        } else {
        
            self.sendButton.backgroundColor = kSystemColor;
        }
    };
    
    return cell;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    _layout.itemSize = CGSizeMake(SCREEN_WIDTH, self.bounds.size.height - 50);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.layer.cornerRadius = self.sendButton.bounds.size.height / 2;
}

@end

//
//  WH_liveView.m
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_liveView.h"
#import "Ipodcast.h"
#import "WH_UserImageViewCell.h"
#import "LivesModel.h"
@interface WH_liveView () <UICollectionViewDelegate, UICollectionViewDataSource>
/** 进来倒计时的3秒 */
@property (nonatomic, strong) UILabel *countDownTime;

/** 用户头像和观看人数下面的view */
@property (nonatomic, strong) UIView *backView;
/** 用户头像 */
@property (nonatomic, strong) UIImageView *userImageView;
/** 直播title */
@property (nonatomic, strong) UILabel *labelOfType;
/** 观看人数 */
@property (nonatomic, strong) UILabel *labelOfCount;
/** 观看人的头像 */
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/** 右上角的日期 */
@property (nonatomic, strong) UILabel *labelOfTime;
/** 播客号 */
@property (nonatomic, strong) UILabel *labelOfNumber;
/** 聊天的tableView列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 选择音乐的按钮 */
@property (nonatomic, strong) UIButton *buttonOfMusic;
/** 转换摄像头 */
@property (nonatomic, strong) UIButton *cameraChange;
/** 返回停止按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 送礼物的Button */
@property (nonatomic, strong) UIButton *giftButton;
/** 点亮 */
@property (nonatomic, strong) UIButton *lightHeart;
/** 判断是look还是live */
@property (nonatomic, assign) VCType vcType;


@end

@implementation WH_liveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withVCType:(VCType)vcType {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.vcType = vcType;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {

    /** bottomView */
    // 这里的bottomView要做动画用frame写比较好
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 60)];
    [self addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor clearColor];
    
     /** 返回键 */
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-20);
        make.width.height.mas_equalTo(40);
    }];
    self.backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.backButton setImage:[UIImage imageNamed:@"live_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton layoutIfNeeded];
    self.backButton.layer.masksToBounds = YES;
    self.backButton.layer.cornerRadius = self.backButton.bounds.size.width / 2;
    self.backButton.tag = 888;

    /** 用户头像那块 */
    self.backView = [[UIView alloc] init];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.equalTo(self.backView.mas_width).multipliedBy(0.4);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.5);
    }];
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    /** 用户头像 */
    self.userImageView = [[UIImageView alloc] init];
    [self.backView addSubview:_userImageView];
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.backView.mas_centerY);
        make.left.equalTo(self.backView.mas_left);
        make.width.height.equalTo(self.backView.mas_height);
    }];
    self.userImageView.backgroundColor = [UIColor redColor];
    [self.userImageView layoutIfNeeded];
    self.userImageView.layer.masksToBounds = YES;
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width / 2;
    /** 观看人数和标题 */
    self.labelOfType = [[UILabel alloc] init];
    [self.backView addSubview:_labelOfType];
    [_labelOfType mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.userImageView.mas_right).offset(5);
        make.bottom.equalTo(self.userImageView.mas_centerY);
    }];
    self.labelOfType.text = @"直播";
    self.labelOfType.textColor = [UIColor whiteColor];
    self.labelOfType.font = [UIFont systemFontOfSize:13];
    
    self.labelOfCount = [[UILabel alloc] init];
    [self.backView addSubview:_labelOfCount];
    [_labelOfCount mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.labelOfType.mas_left);
        make.top.equalTo(self.userImageView.mas_centerY);
    }];
    self.labelOfCount.text = @"0";
    self.labelOfCount.textColor = [UIColor whiteColor];
    self.labelOfCount.font = [UIFont systemFontOfSize:13];

    
    /** 观看人的头像 */
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self addSubview:_collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.backView.mas_right).offset(10);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.backView.mas_centerY);
        make.height.equalTo(self.backView.mas_height);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[WH_UserImageViewCell class] forCellWithReuseIdentifier:@"poolOfCollectionView"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.labelOfTime = [[UILabel alloc] init];
    [self addSubview:_labelOfTime];
    [self.labelOfTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.collectionView.mas_bottom).offset(10);
    }];
//    self.labelOfTime.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.labelOfTime.textColor = [UIColor whiteColor];
    [self getDate];
    self.labelOfTime.font = [UIFont systemFontOfSize:13];
    
    /** 用户播客号 */
    self.labelOfNumber = [[UILabel alloc] init];
    [self addSubview:_labelOfNumber];
    [self.labelOfNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.labelOfTime.mas_right);
        make.top.equalTo(self.labelOfTime.mas_bottom).offset(5);
    }];
//    self.labelOfNumber.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.labelOfNumber.textColor = [UIColor whiteColor];
    NSUserDefaults *userDeasults = [NSUserDefaults standardUserDefaults];
   NSNumber *num = [userDeasults objectForKey:@"userId"];
    self.labelOfNumber.text = [NSString stringWithFormat:@"播客号:%@",num];
    self.labelOfNumber.font = [UIFont systemFontOfSize:13];
    
    /** 聊天的tableView */
    /** 判断创建哪个Button */
    if (self.vcType == Live) {
    
        /** 进入页面的倒计时 */
        [self countDown:3];

        self.giftButton.hidden = YES;
        self.lightHeart.hidden = YES;
        [self createLive];
    
    } else if (self.vcType == Look) {
    
        self.cameraChange.hidden = YES;
        self.buttonOfMusic.hidden = YES;
        [self createLook];
    }

}
#pragma mark ------------  自己直播的页面  -----------
- (void)createLive {

    /** 转换摄像头 */
    self.cameraChange = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:_cameraChange];
    [self.cameraChange mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backButton.mas_left).offset(-15);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.equalTo(self.backButton.mas_width);
    }];
    self.cameraChange.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.cameraChange layoutIfNeeded];
    self.cameraChange.layer.masksToBounds = YES;
    self.cameraChange.layer.cornerRadius = self.cameraChange.bounds.size.width / 2;
    [self.cameraChange setImage:[UIImage imageNamed:@"live_changecamera"] forState:UIControlStateNormal];
    [self.cameraChange addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cameraChange.tag = 999;
    
    /** 选择音乐的按钮 */
    self.buttonOfMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:_buttonOfMusic];
    [_buttonOfMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.cameraChange.mas_left).offset(-15);
        make.centerY.equalTo(self.cameraChange.mas_centerY);
        make.width.height.equalTo(self.cameraChange.mas_width);
    }];
    [self.buttonOfMusic layoutIfNeeded];
    self.buttonOfMusic.layer.masksToBounds = YES;
    self.buttonOfMusic.layer.cornerRadius = self.buttonOfMusic.bounds.size.width / 2;
    self.buttonOfMusic.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.buttonOfMusic setImage:[UIImage imageNamed:@"live_music"] forState:UIControlStateNormal];
    [self.buttonOfMusic addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonOfMusic.tag = 777;

}
#pragma mark ------------  观看直播的页面  -----------
- (void)createLook {

    /** 送礼物的Button */
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:_giftButton];
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.backButton.mas_left).offset(-15);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.equalTo(self.backButton.mas_width);
    }];
    self.giftButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.giftButton layoutIfNeeded];
    self.giftButton.layer.masksToBounds = YES;
    self.giftButton.layer.cornerRadius = self.giftButton.bounds.size.width / 2;
//    [self.giftButton setImage:[UIImage imageNamed:@"look_gift"] forState:UIControlStateNormal];
    [self.giftButton setTitle:@"🎁" forState:UIControlStateNormal];
    [self.giftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.giftButton.tag = 666;
    
    /** 点亮的按钮 */
    self.lightHeart = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:_lightHeart];
    [_lightHeart mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.giftButton.mas_left).offset(-15);
        make.centerY.equalTo(self.giftButton.mas_centerY);
        make.width.height.equalTo(self.giftButton.mas_width);
    }];
    self.lightHeart.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    [self.lightHeart setImage:[UIImage imageNamed:@"look_lightheart"] forState:UIControlStateNormal];
    [self.lightHeart layoutIfNeeded];
    self.lightHeart.layer.masksToBounds = YES;
    self.lightHeart.layer.cornerRadius = self.lightHeart.bounds.size.height / 2;
    [self.lightHeart setTitle:@"💗" forState:UIControlStateNormal];
    [self.lightHeart addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.lightHeart.tag = 555;

}

#pragma mark ------------  获取当前日期  -----------
- (void)getDate {

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    self.labelOfTime.text = dateString;
}

#pragma mark ------------  collectionView的代理方法  -----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WH_UserImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"poolOfCollectionView" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    return cell;
}


- (void)layoutSubviews {

    [super layoutSubviews];
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = self.backView.bounds.size.height / 2;
    
    
    
    _layout.itemSize = CGSizeMake(self.userImageView.bounds.size.width, self.userImageView.bounds.size.height);
    _layout.minimumLineSpacing = 5;
    _layout.minimumInteritemSpacing = 0;
    
    _labelOfTime.clipsToBounds = YES;
    _labelOfTime.layer.cornerRadius = self.labelOfTime.bounds.size.height / 2;
    
    _labelOfNumber.clipsToBounds = YES;
    _labelOfNumber.layer.cornerRadius = self.labelOfNumber.bounds.size.height / 2;
}

#pragma mark ------------  倒计时方法  -----------
- (void)countDown:(int)count {
    
    if(count <= 0){
        //倒计时已到，作需要作的事吧。
        return;
    }
    #pragma mark ------------  注意这个必须要在这里创建  -----------
    self.countDownTime = [[UILabel alloc] init];
    [self addSubview:_countDownTime];
    [self.countDownTime mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.6);
        make.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    self.countDownTime.textAlignment = NSTextAlignmentCenter;
    self.countDownTime.font = [UIFont systemFontOfSize:100];
    self.countDownTime.textColor = [UIColor whiteColor];
    self.countDownTime.text = [NSString stringWithFormat:@"%d", count];
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.countDownTime.alpha = 0;
                         _countDownTime.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                     }
                     completion:^(BOOL finished) {
                         [_countDownTime removeFromSuperview];
                         //递归调用，直到计时为零
                         [self countDown:count -1];
                     }
     ];
}

#pragma mark ------------ 按钮方法 -----------
- (void)buttonClick:(UIButton *)btn {

    if (self.buttonAction) {
        
        self.buttonAction(btn);
    }
}
#pragma mark ------------  set赋值  -----------
- (void)setModel:(LivesModel *)model {

    _model = model;
    
    NSString *str = [NSString stringWithFormat:@"http://img.meelive.cn/%@",_model.creator.portrait];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:str]];
    
    self.labelOfCount.text = _model.online_users;
}

@end

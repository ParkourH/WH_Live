//
//  JYJ_HeadTableView.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_HeadTableView.h"
#import "Masonry.h"
#import "JYJ_EditViewController.h"
#import "MineViewController.h"
#import "JYJ_LoginViewController.h"

@interface JYJ_HeadTableView()

@end
@implementation JYJ_HeadTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    
    
    // 头像
    self.headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head_zhanwei"]];
    [self addSubview:_headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.85);
        make.height.mas_equalTo(self.bounds.size.height / 3);
        make.width.mas_equalTo(self.bounds.size.height / 3);
    }];
    self.headImageView.layer.cornerRadius = self.bounds.size.height / 6;
    self.headImageView.clipsToBounds = YES;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleNext:)];
    [self.headImageView addGestureRecognizer:tap];
    // 昵称
       self.nameLabel = [[UILabel alloc]init];
    [self addSubview:_nameLabel];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(_headImageView.mas_bottom).offset(20);
        
    }];
    
    
        self.nameLabel.textAlignment = 1;
        
   
    
    //性别
    self.sexImage = [[UIImageView alloc]init];
    [self addSubview:self.sexImage];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(10);
        make.top.equalTo(_headImageView.mas_bottom).offset(20);
        

        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];

    self.logoLabel = [[UILabel alloc]init];
    [self addSubview:_logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
    }];
    self.logoLabel.textAlignment = 1;
    self.logoLabel.textColor = [UIColor whiteColor];
    
    self.signatureLabel = [[UILabel alloc]init];
    [self addSubview:_signatureLabel];
    self.signatureLabel.textAlignment = 1;
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.logoLabel.mas_bottom).offset(15);
    }];
    self.signatureLabel.text = @"签名:111";
    self.signatureLabel.textColor = [UIColor whiteColor];
}
- (void)handleNext:(UITapGestureRecognizer *)tap {
    MineViewController *mine = (MineViewController *)self.nextResponder.nextResponder.nextResponder ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults objectForKey:@"userName"];
    if (name == nil) {
        JYJ_LoginViewController *login = [[JYJ_LoginViewController alloc]init];
        mine.tabBarController.tabBar.hidden = YES;
        mine.hidesBottomBarWhenPushed = YES;
        [mine.navigationController pushViewController:login animated:YES];
        mine.hidesBottomBarWhenPushed = NO;
    }else {
    JYJ_EditViewController *edit = [[JYJ_EditViewController alloc]init];
   
        
    mine.tabBarController.tabBar.hidden = YES;
    mine.hidesBottomBarWhenPushed = YES;
    [mine.navigationController pushViewController:edit animated:YES];
    mine.hidesBottomBarWhenPushed = NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

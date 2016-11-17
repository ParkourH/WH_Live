//
//  JYJ_SectionView.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_SectionView.h"
#import "Masonry.h"
#import "Ipodcast.h"
@implementation JYJ_SectionView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self createButton];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        UIView *viewOfColor = [[UIView alloc]initWithFrame:CGRectMake(0, 58,SCREEN_WIDTH , 2)];
        [self.contentView addSubview:viewOfColor];
        viewOfColor.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    }
    return self;
}
- (void)createButton {
    // 直播
    self.liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_liveButton];
    [_liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(40);
    }];
    [self.liveButton addTarget:self action:@selector(liveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.liveButton setTitle:@"直播" forState:UIControlStateNormal];
    [self.liveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.liveLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_liveLabel];
    [self.liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.liveButton.mas_right).offset(10);
    }];
    self.liveLabel.textColor = kSystemColor;
    self.liveLabel.text = @"0";
    
    // 关注
    self.attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_attentionButton];
    [self.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.attentionButton addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
    self.attentionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_attentionLabel];
    [self.attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.attentionButton.mas_right).offset(10);
    }];
    self.attentionLabel.textColor = kSystemColor;
    self.attentionLabel.text = @"3";
    
    //粉丝
    self.fanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.fanButton];
    [_fanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_fanButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [_fanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.fanButton addTarget:self action:@selector(fanAction:) forControlEvents:UIControlEventTouchUpInside];
    self.fanLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_fanLabel];
    [_fanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.fanButton.mas_right).offset(10);
    }];
    self.fanLabel.textColor = kSystemColor;
    self.fanLabel.text = @"1";
    
}
- (void)live:(Block)live attention:(Block)attention fan:(Block)fan {
    self.handleLive = live;
    self.handleAttention = attention;
    self.handleFan = fan;
}
- (void)liveAction:(UIButton *)button {
    self.handleLive(button);
}
- (void)attentionAction:(UIButton *)button {
    self.handleAttention(button);
}
- (void)fanAction:(UIButton *)button {
    self.handleFan(button);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  JYJ_AttentionTableViewCell.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_AttentionTableViewCell.h"
#import "Masonry.h"
#import "Ipodcast.h"
@implementation JYJ_AttentionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    self.headImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_headImage];
    self.nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    self.sexImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_sexImage];
    self.signLabel =[[UILabel alloc]init];
    [self.contentView addSubview:_signLabel];
    self.plusImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_plus"]];
    [self.contentView addSubview:_plusImage];
    self.plusImage.hidden = YES;
    self.cancleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_duihao"]];
    [self.contentView addSubview:_cancleImage];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    self.headImage.layer.cornerRadius = 30;
    self.headImage.clipsToBounds = YES;
    self.headImage.backgroundColor  = kSystemColor;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImage.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.5);
    }];
    self.nameLabel.text = @"一一悲伤";
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(10);
       make.centerY.equalTo(self.mas_centerY).multipliedBy(0.5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    self.sexImage.backgroundColor = kSystemColor;
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.headImage.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.3);

    }];
    self.signLabel.text = @"sdf";
    [self.plusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.cancleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

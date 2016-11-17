//
//  JYJ_MineTableViewCell.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_MineTableViewCell.h"
#import "Masonry.h"
@implementation JYJ_MineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_titleLabel];
    self.rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_rightLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(30);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-40);
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

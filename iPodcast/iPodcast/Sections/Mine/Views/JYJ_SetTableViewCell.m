//
//  JYJ_SetTableViewCell.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_SetTableViewCell.h"
#import "Masonry.h"
@implementation JYJ_SetTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    self.setTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_setTitleLabel];
  
    self.rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_rightLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.setTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.setTitleLabel.textColor = [UIColor blackColor];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-40);
    }];
    self.rightLabel.textColor = [UIColor lightGrayColor];
    
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

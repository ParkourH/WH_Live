//
//  JYJ_EditTableViewCell.m
//  iPodcast
//
//  Created by 冀永金 on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "JYJ_EditTableViewCell.h"
#import "Masonry.h"
@implementation JYJ_EditTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    self.editTitleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_editTitleLabel];
    self.rightImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_rightImage];
    self.rightLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_rightLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.editTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
    }];
   
    self.editTitleLabel.textColor = [UIColor blackColor];
   [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.equalTo(self.mas_right).offset(-40);
       make.top.equalTo(self.mas_top).offset(10);
       make.height.mas_equalTo(80);
       make.width.mas_equalTo(80);
   }];
        

    //self.rightImage.backgroundColor = [UIColor blueColor];
    self.rightImage.layer.cornerRadius = 40;
    self.rightImage.clipsToBounds = YES;
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

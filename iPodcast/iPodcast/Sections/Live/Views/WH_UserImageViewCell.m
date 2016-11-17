//
//  WH_UserImageViewCell.m
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_UserImageViewCell.h"

@implementation WH_UserImageViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {

    self.imageViewOfUser = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageViewOfUser];
    self.imageViewOfUser.backgroundColor = [UIColor cyanColor];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.imageViewOfUser.layer.masksToBounds = YES;
    self.imageViewOfUser.layer.cornerRadius = self.imageViewOfUser.bounds.size.width / 2;
}


@end

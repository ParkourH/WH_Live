//
//  XK_ListViewCell.m
//  iPodcast
//
//  Created by Sober on 16/10/22.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "XK_ListViewCell.h"

@implementation XK_ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  XK_HotTableViewCell.m
//  iPodcast
//
//  Created by Sober on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "XK_HotTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation XK_HotTableViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellDataModel:(LivesModel *)model{

    if (model.username) {
        
        self.nick.text = model.username;
        self.bigPortrait.backgroundColor = [UIColor cyanColor];
    } else {
    
        NSString *urlStr;
        if ([model.creator.portrait rangeOfString:@"http"].location !=NSNotFound) {
            //$$字符串判断
            urlStr= model.creator.portrait;
            
        }else{
            urlStr= [NSString stringWithFormat:@"http://img.meelive.cn/%@",model.creator.portrait];
        }
        NSLog(@"%@",urlStr);
        [self.smallPortrait sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageCacheMemoryOnly];
        [self.bigPortrait sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageCacheMemoryOnly];
        self.smallPortrait.layer.cornerRadius = 22;
        self.smallPortrait.layer.masksToBounds = YES;
        self.nick.text = model.creator.nick;
        self.online_users.text = model.online_users;
        self.hometown.text = model.creator.hometown;
        self.desc.text = model.creator.desc;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

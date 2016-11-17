//
//  XK_NearbyCell.m
//  iPodcast
//
//  Created by Sober on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "XK_NearbyCell.h"

@implementation XK_NearbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellDataModel:(LivesModel *)model{
    NSString *urlStr;
    if ([model.creator.portrait rangeOfString:@"http"].location !=NSNotFound) {
        //$$字符串判断
        urlStr= model.creator.portrait;
        
    }else{
        urlStr= [NSString stringWithFormat:@"http://img.meelive.cn/%@",model.creator.portrait];
    }
    NSLog(@"%@",urlStr);
    [self.portrait sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageCacheMemoryOnly];
}
@end

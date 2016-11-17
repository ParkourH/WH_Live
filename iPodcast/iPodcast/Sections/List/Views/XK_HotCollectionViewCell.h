//
//  XK_HotCollectionViewCell.h
//  iPodcast
//
//  Created by Sober on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//
#import "LivesModel.h"
#import <UIKit/UIKit.h>

typedef void(^LookLive)(NSIndexPath *indexPath);

@interface XK_HotCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSArray *listData;

@property (nonatomic, copy) LookLive looklive;

@end

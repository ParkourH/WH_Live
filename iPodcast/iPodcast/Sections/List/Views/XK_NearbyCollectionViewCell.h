//
//  XK_NearbyCollectionViewCell.h
//  iPodcast
//
//  Created by Sober on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//
#import "LivesModel.h"
#import <UIKit/UIKit.h>

@interface XK_NearbyCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray *livesData;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

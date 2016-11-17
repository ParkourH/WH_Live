//
//  WH_GiftInfoCell.h
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WH_GiftModel;
@interface WH_GiftInfoCell : UICollectionViewCell

@property (nonatomic, strong) WH_GiftModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfSeleted;


@end

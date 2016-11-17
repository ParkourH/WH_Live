//
//  WH_GiftCollectionViewCell.h
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WH_GiftModel;
typedef void(^SendGift)(WH_GiftModel *model, UIImageView *imageViewOfSeleted);

@interface WH_GiftCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) SendGift sendGift;

@end

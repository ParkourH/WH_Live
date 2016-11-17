//
//  XK_NearbyCell.h
//  iPodcast
//
//  Created by Sober on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivesModel.h"
@interface XK_NearbyCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portrait;
-(void)setCellDataModel:(LivesModel *)model;
@end

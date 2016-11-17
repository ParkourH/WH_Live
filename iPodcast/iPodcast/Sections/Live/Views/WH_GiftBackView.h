//
//  WH_GiftBackView.h
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WH_GiftModel;
typedef void(^SendPresent)(UIButton *sender, WH_GiftModel *model, BOOL isEnough);

@interface WH_GiftBackView : UIView

@property (nonatomic, copy) SendPresent sendPresent;
@end

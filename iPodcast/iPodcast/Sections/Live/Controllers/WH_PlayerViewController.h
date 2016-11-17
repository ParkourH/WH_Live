//
//  WH_PlayerViewController.h
//  iPodcast
//
//  Created by ParkourH on 16/10/26.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LivesModel;
@interface WH_PlayerViewController : UIViewController

@property (nonatomic, strong) LivesModel *model;
//+ (instancetype)sharePlayer;
@end

//
//  XK_HotTableViewCell.h
//  iPodcast
//
//  Created by Sober on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivesModel.h"
@interface XK_HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hometown;
@property (weak, nonatomic) IBOutlet UIImageView *smallPortrait;
@property (weak, nonatomic) IBOutlet UIImageView *bigPortrait;

@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *online_users;

@property (weak, nonatomic) IBOutlet UILabel *desc;




-(void)setCellDataModel:(LivesModel *)model;
@end

//
//  WH_SearchMusicCell.h
//  iPodcast
//
//  Created by ParkourH on 16/10/29.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WH_Results, WH_Track, UAProgressView;
@interface WH_SearchMusicCell : UITableViewCell

//@property (nonatomic, strong) WH_Results *model;
@property (weak, nonatomic) IBOutlet UIImageView *loadMusic;

@property (nonatomic, strong) WH_Track *modelOfTrack;
@property (nonatomic, strong) UAProgressView *progressView;
@property (nonatomic, strong) UILabel *loadProgress;

@property (nonatomic, strong) UIButton *playMusic;
@end

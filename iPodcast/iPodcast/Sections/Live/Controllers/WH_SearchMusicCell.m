//
//  WH_SearchMusicCell.m
//  iPodcast
//
//  Created by ParkourH on 16/10/29.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_SearchMusicCell.h"
#import "WH_MusicModel.h"
#import "Ipodcast.h"

@interface WH_SearchMusicCell ()

@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *musicSinger;
@property (weak, nonatomic) IBOutlet UILabel *musicTime;


@end

@implementation WH_SearchMusicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    
    self.progressView = [[UAProgressView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    self.progressView.tintColor = kSystemColor;
    
    self.loadProgress = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_loadProgress];
    [_loadProgress mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.progressView);
    }];
    [self.progressView setCentralView:_loadProgress];
    _loadProgress.textAlignment = NSTextAlignmentCenter;
    _loadProgress.backgroundColor = [UIColor clearColor];
    _loadProgress.font = [UIFont systemFontOfSize:8];
    _progressView.hidden = YES;
    
    self.playMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_playMusic];
    [self.playMusic mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    self.playMusic.backgroundColor = kSystemColor;
    [self.playMusic layoutIfNeeded];
    self.playMusic.layer.masksToBounds = YES;
    self.playMusic.layer.cornerRadius = self.playMusic.bounds.size.height / 2;
    self.playMusic.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.playMusic setTitle:@"使用" forState:UIControlStateNormal];
    self.playMusic.hidden = YES;
}

- (void)prepareForReuse {

    [super prepareForReuse];
}


- (void)layoutSubviews {

    [super layoutSubviews];
    
}


- (void)setModelOfTrack:(WH_Track *)modelOfTrack {

    _modelOfTrack = modelOfTrack;
    
    self.musicName.text = _modelOfTrack.name;
    self.musicSinger.text = _modelOfTrack.singer.name;
    NSInteger allTime = _modelOfTrack.audio.length;
    if (allTime % 60 < 10) {
        
        _musicTime.text = [NSString stringWithFormat:@"%ld:0%ld", allTime / 60, allTime % 60];
    } else if (allTime % 60 > 10) {
        
        _musicTime.text = [NSString stringWithFormat:@"%ld:%ld", allTime / 60, allTime % 60];
    }
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

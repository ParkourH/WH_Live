//
//  JYJ_SectionView.h
//  iPodcast
//
//  Created by 冀永金 on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(UIButton *button);
@interface JYJ_SectionView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *liveButton;
@property (nonatomic, strong) UILabel *liveLabel;

@property (nonatomic, strong) UIButton *attentionButton;
@property (nonatomic, strong) UILabel *attentionLabel;

@property (nonatomic, strong) UIButton *fanButton;
@property (nonatomic, strong) UILabel *fanLabel;
@property (nonatomic, copy) Block handleLive;
@property (nonatomic, copy) Block handleAttention;
@property (nonatomic, copy) Block handleFan;

- (void)live:(Block)live attention:(Block)attention fan:(Block)fan;



@end

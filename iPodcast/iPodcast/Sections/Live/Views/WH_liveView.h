//
//  WH_liveView.h
//  iPodcast
//
//  Created by ParkourH on 16/10/25.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LivesModel;
typedef NS_ENUM(NSUInteger, VCType) {
    Look,
    Live,
};

typedef void(^ButtonAction)(UIButton *btn);

@interface WH_liveView : UIView

/** 由于送礼物的动画效果, 这里需要把下面的视图放到一个view上 */
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, copy) ButtonAction buttonAction;

- (instancetype)initWithFrame:(CGRect)frame withVCType:(VCType)vcType;

/** 赋值 */
@property (nonatomic, strong) LivesModel *model;
@end

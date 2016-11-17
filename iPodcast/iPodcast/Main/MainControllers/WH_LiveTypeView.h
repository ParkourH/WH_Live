//
//  WH_LiveTypeView.h
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  WH_liveViewDelegate <NSObject>

- (void)didSelectBtnWithBtnTag:(NSInteger)tag;

@end

@interface WH_LiveTypeView : UIView

@property (nonatomic, weak) id <WH_liveViewDelegate>delegate;
- (void)show;
@end

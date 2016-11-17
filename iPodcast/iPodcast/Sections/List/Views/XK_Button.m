//
//  XK_Button.m
//  iPodcast
//
//  Created by ParkourH on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "XK_Button.h"

@implementation XK_Button

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {

    self = [super initWithFrame:frame];
    if (self) {
    
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        self.titleLabel.font = font;
        
    }
    return self;
}

@end

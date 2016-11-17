//
//  WH_LiveTypeView.m
//  iPodcast
//
//  Created by ParkourH on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_LiveTypeView.h"
#import "Ipodcast.h"

@interface WH_LiveTypeView ()

@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UIButton *gameButton;

@property (nonatomic, strong) UIButton *personButton;

@property (nonatomic, strong) UIButton *backButton;
@end

@implementation WH_LiveTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self createSubViews];
    }
    return self;
}
#pragma mark ------------  创建子视图  -----------
- (void)createSubViews {

    self.whiteView = [[UIView alloc] init];
    [self addSubview:_whiteView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    
    // 游戏直播
    self.gameButton = [self buttonAnimationWithFrame:CGRectMake(SCREEN_WIDTH / 4 - 30, SCREEN_HEIGHT - 150 , 60, 100) imageName:@"live_game" titleName:@"游戏" animationFrame:CGRectMake(SCREEN_WIDTH / 4 - 30, SCREEN_HEIGHT - 180, 60, 100) delay:0.0];
    _gameButton.tag = 100;
//    self.gameButton.backgroundColor = [UIColor redColor];
    [_gameButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 真人秀直播按钮..
    self.personButton = [self buttonAnimationWithFrame:CGRectMake((SCREEN_WIDTH / 4) * 3 - 30, SCREEN_HEIGHT - 150, 60, 100 )imageName:@"live_person" titleName:@"真人秀" animationFrame:CGRectMake((SCREEN_WIDTH / 4) * 3 - 30, SCREEN_HEIGHT - 180, 60, 100) delay:0.1];
    _personButton.tag = 200;
//    self.personButton.backgroundColor = [UIColor redColor];
    [_personButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 返回按钮
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_backButton];
    [self.backButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.backButton.backgroundColor = [UIColor blackColor];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    self.backButton.tag = 300;
    [_backButton addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ------------  创建自定义带动画Button的方法  -----------
- (UIButton *)buttonAnimationWithFrame:(CGRect)frame imageName:(NSString *)imageName titleName:(NSString *)title animationFrame:(CGRect)animationFrame delay:(CGFloat)delay {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [self addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, -btn.titleLabel.bounds.size.width)];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height, -btn.imageView.frame.size.width, 0, 0)];
    
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
       
        btn.frame = animationFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    return btn;
}

#pragma mark ------------  Layout布局  -----------
- (void)layoutSubviews {

    [super layoutSubviews];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark ------------    -----------
- (void)btnClick:(UIButton *)btn {
    
    [self removeView];

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBtnWithBtnTag:)]) {
        
        [self.delegate didSelectBtnWithBtnTag:btn.tag];
    }
}

#pragma mark ------------  移除self  -----------
- (void)removeView {

    [self removeFromSuperview];
}

#pragma mark ------------  取消直播  -----------
- (void)cancelAnimation {

    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            
            [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                
                view.frame = CGRectMake(view.frame.origin.x, SCREEN_HEIGHT, view.bounds.size.width, 60);
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
            }];
        }
    }

}

#pragma mark ------------  show  -----------
- (void)show {

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

#pragma mark ------------  点击其他地方取消直播  -----------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    CGFloat locationY = currentPosition.y;
    if (locationY < SCREEN_HEIGHT - 200) {
        
        [self cancelAnimation];
    }
}


@end

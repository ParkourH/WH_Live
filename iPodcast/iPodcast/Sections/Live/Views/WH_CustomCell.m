//
//  WH_CustomCell.m
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_CustomCell.h"
#import "WH_GiftModel.h"


@interface WH_CustomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelOfGiftName;

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation WH_CustomCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithRow:(NSInteger)row {

    self = [super initWithRow:row];
    if (self) {
        
        self = [[NSBundle mainBundle] loadNibNamed:@"WH_CustomCell" owner:self options:0].firstObject;
        self.backView.clipsToBounds = YES;
        self.userImageView.clipsToBounds = YES;
        self.userImageView.layer.borderWidth = 1;
        self.userImageView.layer.borderColor = [UIColor cyanColor].CGColor;
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.backView.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.frame) * 0.5;
}

/** set方法 */
- (void)setModel:(WH_GiftModel *)model {

    _model = model;
    self.userImageView.image = [UIImage imageNamed:_model.userImg];
    self.userName.text = _model.sender;
    self.labelOfGiftName.text = [NSString stringWithFormat:@"送了一个【%@】", model.giftName];
    self.giftImageView.image = [UIImage imageNamed:model.giftImg];
}
/** 自定义cell的展示动画 */
- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag {

    // 这里直接使用父类中的动画, 如果用户想自定义可在这里实现动画, 不调用父类的方法(这个方法在UIView动画的animations回调执行)
    [super customDisplayAnimationOfShowShakeAnimation:YES];
}

/** 自定义cell的隐藏动画 */
- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag {

    [super customHideAnimationOfShowShakeAnimation:YES];
}



@end

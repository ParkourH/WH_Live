//
//  WH_GiftInfoCell.m
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_GiftInfoCell.h"
#import "WH_GiftModel.h"

@interface WH_GiftInfoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewOfGift;
@property (weak, nonatomic) IBOutlet UILabel *experienceOfUser;
@property (weak, nonatomic) IBOutlet UILabel *giftMoney;


@end

@implementation WH_GiftInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setModel:(WH_GiftModel *)model {

    _model = model;
    
    self.imageViewOfGift.image = [UIImage imageNamed:_model.giftImg];
    NSString *string = [NSString stringWithFormat:@"%ld", _model.giftExperience];
    self.experienceOfUser.text = [[@"+" stringByAppendingString:string] stringByAppendingString:@"经验值"];
    self.giftMoney.text = [[NSString stringWithFormat:@"%ld", _model.giftCost] stringByAppendingString:@"💎"];
}


- (void)prepareForReuse {

    [super prepareForReuse];
    
    self.imageViewOfSeleted.hidden = YES;
}

@end

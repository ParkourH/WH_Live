//
//  WH_GiftModel.h
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresentModelAble.h"
@interface WH_GiftModel : NSObject <PresentModelAble>

@property (nonatomic, copy) NSString *sender;
//@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *userImg;

@property (nonatomic, copy) NSString *giftName;

@property (nonatomic, copy) NSString *giftImg;

@property (nonatomic, assign) NSInteger giftCost;

@property (nonatomic, assign) NSInteger giftExperience;

- (instancetype)initWithDic:(NSDictionary *)dic;

+ (WH_GiftModel *)modelWithDic:(NSDictionary *)dic;
@end

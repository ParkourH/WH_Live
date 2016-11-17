//
//  WH_GiftModel.m
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_GiftModel.h"

@implementation WH_GiftModel

- (instancetype)initWithDic:(NSDictionary *)dic {

    self = [super init];
    if (self) {
        
        
        self.sender = @"王鍠";
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (WH_GiftModel *)modelWithDic:(NSDictionary *)dic {

    return [[self alloc] initWithDic:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    
}

- (id)valueForUndefinedKey:(NSString *)key {

    return nil;
}


@end

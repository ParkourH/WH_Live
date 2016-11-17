//
//  WH_GiftCollectionViewCell.m
//  iPodcast
//
//  Created by ParkourH on 16/10/27.
//  Copyright © 2016年 ParkourH. All rights reserved.
//

#import "WH_GiftCollectionViewCell.h"
#import "Ipodcast.h"
#import "WH_GiftInfoCell.h"
#import "WH_GiftModel.h"
@interface WH_GiftCollectionViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *mArrOfGift;
@end
@implementation WH_GiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self handleData];
        [self createCollectionView];
    }
    return self;
}
/** 处理本地json文件 */
- (void)handleData {

    self.mArrOfGift = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Present" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSArray *giftList = [dictionary objectForKey:@"gift"];
    
    for (NSDictionary *dic in giftList) {
        
        WH_GiftModel *model = [WH_GiftModel modelWithDic:dic];
        [self.mArrOfGift addObject:model];
    }
    /** 如果网络获取要reloaddata */
}

- (void)createCollectionView {

    self.layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (SCREEN_WIDTH - 8) / 4;
    self.layout.itemSize = CGSizeMake(width, width * 1.3);
    self.layout.minimumLineSpacing = 2;
    self.layout.minimumInteritemSpacing = 2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:_layout];
    [self.contentView addSubview:_collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
//    [self.collectionView registerClass:[WH_GiftInfoCell class] forCellWithReuseIdentifier:@"pool"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"WH_GiftInfoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"pool"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mArrOfGift.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    WH_GiftInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pool" forIndexPath:indexPath];
    
    cell.model = self.mArrOfGift[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    WH_GiftInfoCell *cell = (WH_GiftInfoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.imageViewOfSeleted.hidden == NO) {
        
        cell.imageViewOfSeleted.hidden = YES;
    } else {
    
        cell.imageViewOfSeleted.hidden = NO;
    }
    if (self.sendGift) {
        
        self.sendGift(cell.model, cell.imageViewOfSeleted);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WH_GiftInfoCell *cell = (WH_GiftInfoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.imageViewOfSeleted.hidden = YES;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
}

@end

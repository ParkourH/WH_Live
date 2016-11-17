//
//  XK_NearbyCollectionViewCell.m
//  iPodcast
//
//  Created by Sober on 16/10/20.
//  Copyright © 2016年 ParkourH. All rights reserved.
#import "XK_NearbyHead.h"
#import "Ipodcast.h"
#import "XK_NearbyCell.h"
#import "XK_NearbyCollectionViewCell.h"
@interface XK_NearbyCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation XK_NearbyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCollectionView];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-14)/3, (SCREEN_WIDTH-14)/3);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:layout];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XK_NearbyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XK_NearbyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XK_NearbyHead" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XK_NearbyHead"];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 50);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    XK_NearbyHead *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XK_NearbyHead" forIndexPath:indexPath];
    head.array = self.livesData;
    return head;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _livesData.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XK_NearbyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XK_NearbyCell" forIndexPath:indexPath];
    LivesModel *model=_livesData[indexPath.row];
    
    [cell setCellDataModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)setLivesData:(NSMutableArray *)livesData{
    _livesData = livesData;
    [self.collectionView reloadData];
}
@end

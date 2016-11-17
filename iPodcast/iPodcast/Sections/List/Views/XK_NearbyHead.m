//
//  XK_NearbyHead.m
//  iPodcast
//
//  Created by Sober on 16/10/21.
//  Copyright © 2016年 ParkourH. All rights reserved.
#import "LivesModel.h"
#import "XK_NearbyCollectionViewCell.h"
#import "XK_NearbyHead.h"
#import "ListViewController.h"
@implementation XK_NearbyHead

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)select:(id)sender {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    self.array = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    XK_NearbyCollectionViewCell *neary = (XK_NearbyCollectionViewCell *)self.nextResponder.nextResponder.nextResponder;
    array = neary.livesData;
    UIAlertAction *all = [UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
               [neary.collectionView reloadData];
           }];
    UIAlertAction *man = [UIAlertAction actionWithTitle:@"只看男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (LivesModel *model in neary.livesData) {
            if (model.creator.gender == 1) {
                [self.array addObject:model];
            }
        }
        neary.livesData = self.array;
      [neary.collectionView reloadData];
        neary.livesData = array;
    }];
    UIAlertAction *woman = [UIAlertAction actionWithTitle:@"只看女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (LivesModel *model in neary.livesData) {
            if (model.creator.gender == 0) {
                [self.array addObject:model];
            }
        }
        neary.livesData = self.array;
        [neary.collectionView reloadData];
        [neary.livesData removeAllObjects];
        neary.livesData = array;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheetController addAction:all];
    [actionSheetController addAction:man];
    [actionSheetController addAction:woman];
    
    [actionSheetController addAction:cancelAction];
    
    ListViewController *vc = (ListViewController *)self.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder.nextResponder;
    [vc presentViewController:actionSheetController animated:YES completion:^{
        NSLog(@"");
    }];
    
    
}

@end

//
//  PresentView.m
//  PresentDemo
//
//  Created by 阮思平 on 16/10/2.
//  Copyright © 2016年 阮思平. All rights reserved.
//

#import "PresentView.h"

#define Margin 20

@interface PresentView ()<PresentViewCellDelegate>

/**
 *  带连乘动画的消息缓存数组
 */
@property (strong, nonatomic) NSMutableArray *dataCaches;
/**
 *  不带连城动画的消息缓存数组
 */
@property (strong, nonatomic)NSMutableArray *nonshakeDataCaches;
/**
 *  记录presentView上的cell
 */
@property (strong, nonatomic) NSMutableArray *showCells;

@end

@implementation PresentView

#pragma mark - Setter/Getter

- (void)setCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
    
    [self setNeedsDisplay];
}

- (NSMutableArray *)dataCaches
{
    if (!_dataCaches) {
        _dataCaches = [NSMutableArray array];
    }
    return _dataCaches;
}

- (NSMutableArray *)nonshakeDataCaches
{
    if (!_nonshakeDataCaches) {
        _nonshakeDataCaches = [NSMutableArray array];
    }
    return _nonshakeDataCaches;
}

- (NSMutableArray *)showCells
{
    if (!_showCells) {
        _showCells = [NSMutableArray array];
    }
    return _showCells;
}

#pragma mark - Initial

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //初始值
    self.showTime = 3;
    
    //添加cell
    self.cellHeight = self.cellHeight ? self.cellHeight : 40;
    _rows           = (int)floor(rect.size.height / (self.cellHeight + Margin));
    CGFloat inset   = rect.size.height - (self.cellHeight + Margin) * _rows + Margin;
    inset           = MAX(0, inset) * 0.5;
    for (int index = 0; index < _rows; index++) {
        CGFloat w             = rect.size.width;
        CGFloat y             = inset + (self.cellHeight + Margin) * index;
        CGFloat x             = -w;
        PresentViewCell *cell = [self.delegate presentView:self cellOfRow:index];
        cell.frame            = CGRectMake(x, y, w, self.cellHeight);
        cell.delegate         = self;
    
        if (cell) {
            
            [self addSubview:cell];
            [self.showCells addObject:cell];
        }
    
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    for (int index = 0; index < self.showCells.count; index++) {
        PresentViewCell *cell = self.showCells[index];
        if (CGRectContainsPoint(cell.frame, point)) {
            if ([self.delegate respondsToSelector:@selector(presentView:didSelectedCellOfRowAtIndex:)]) {
                [self.delegate presentView:self didSelectedCellOfRowAtIndex:index];
            }
            break;
        }
    }
}

#pragma mark - Private

/**
 *  插入带连乘动画的消息
 */
- (void)insertShowShakeAnimationMessages:(NSArray<id<PresentModelAble>> *)models
{
    for (int index = 0; index < models.count; index++) {
        id<PresentModelAble> obj = models[index];
        PresentViewCell *cell = [self examinePresentingCell:obj];
        if (cell) {
            [cell shakeAnimationWithNumber:1];
        }else {
            [self.dataCaches addObject:obj];//将当前消息加到缓存中
            NSArray *cells = [self examinePresentViewCells];
            if (cells.count) {
                cell                   = cells.firstObject;
                //设置后，再次展示的动画才会生效
                cell.showTime          = self.showTime;
                NSArray *objs          = [self subarrayWithObj:obj];
                __weak typeof(self) ws = self;
                [cell showAnimationWithModel:obj showShakeAnimation:YES prepare:^{
                    if ([ws.delegate respondsToSelector:@selector(presentView:configCell:sender:giftName:)]) {
                        [ws.delegate presentView:ws configCell:cell sender:[obj sender] giftName:[obj giftName]];
                    }
                } completion:^(BOOL flag) {
                    if (flag) {
                        [cell shakeAnimationWithNumber:objs.count];
                    }
                }];
            }
        }
    }
}

/**
 *  插入不带连城动画的消息
 */
- (void)insertNonshakeAnimationMessages:(NSArray<id<PresentModelAble>> *)models
{
    if (models) {
        [self.nonshakeDataCaches addObjectsFromArray:models];
    }
    NSArray *freeCells = [self examinePresentViewCells];
    if (self.nonshakeDataCaches.count > 0 && freeCells.count > 0) {
        id<PresentModelAble> obj = self.nonshakeDataCaches.firstObject;
        [self.nonshakeDataCaches removeObjectAtIndex:0];
        PresentViewCell *cell    = freeCells.firstObject;
        cell.showTime            = self.showTime;
        __weak typeof(self) ws   = self;
        [cell showAnimationWithModel:obj showShakeAnimation:NO prepare:^{
            if ([ws.delegate respondsToSelector:@selector(presentView:configCell:sender:giftName:)]) {
                [ws.delegate presentView:ws configCell:cell sender:[obj sender] giftName:[obj giftName]];
            }
        } completion:^(BOOL flag) {
            if (!flag) {
                [cell performSelector:@selector(hiddenAnimationOfShowShake:) withObject:@(NO) afterDelay:self.showTime];
            }
        }];
    }
}

/**
 *  检测插入的消息模型
 */
- (NSArray *)checkElementOfModels:(NSArray<id<PresentModelAble>> *)models
{
    NSMutableArray *siftArray = [NSMutableArray array];
    for (id obj in models) {
        if (![obj conformsToProtocol:@protocol(PresentModelAble)]) {
            DebugLog(@"%@对象没有遵守PresentModelAble协议", obj);
        }else {
            [siftArray addObject:obj];
        }
    }
    return siftArray;
}

/**
 *  检测当前是否有obj类型的礼物消息在展示
 */
- (PresentViewCell *)examinePresentingCell:(id<PresentModelAble>)obj
{
    for (PresentViewCell *cell in self.showCells) {
        if ([cell.sender isEqualToString:[obj sender]] && [cell.giftName isEqualToString:[obj giftName]]) {
            //当前正在展示动画并且不是隐藏动画
            if (cell.state != AnimationStateNone && cell.state != AnimationStateHiding) return cell;
        }
    }
    return nil;
}

/**
 *  检测空闲cell
 */
- (NSArray<PresentViewCell *> *)examinePresentViewCells
{
    NSMutableArray *freeCells = [NSMutableArray array];
    for (PresentViewCell *cell in self.showCells) {
        if (cell.state == AnimationStateNone) {
            [freeCells addObject:cell];
        }
    }
    return freeCells;
}

/**
 *  从缓存中截取与obj类型相同的消息
 */
- (NSArray<id<PresentModelAble>> *)subarrayWithObj:(id<PresentModelAble>)obj
{
    NSMutableArray *array = [NSMutableArray array];
    for (id<PresentModelAble> cache in self.dataCaches) {
        if ([[cache sender] isEqualToString:[obj sender]] && [[cache giftName] isEqualToString:[obj giftName]]) {
            [array addObject:cache];
        }
    }
    [self.dataCaches removeObjectsInArray:array];//取出的数据从缓存中移除
    return array;
}

#pragma mark - Public

- (void)insertPresentMessages:(NSArray<id<PresentModelAble>> *)models showShakeAnimation:(BOOL)flag
{
    NSArray *siftArray = [self checkElementOfModels:models];
    if (!siftArray.count) return;
    if (flag) {
        [self insertShowShakeAnimationMessages:siftArray];
    }else {
        [self insertNonshakeAnimationMessages:siftArray];
    }
}

- (PresentViewCell *)cellForRowAtIndex:(NSUInteger)index
{
    if (index < self.showCells.count)
    {
        return self.showCells[index];
    }
    return nil;
}

#pragma mark - PresentViewCellDelegate

- (void)presentViewCell:(PresentViewCell *)cell showShakeAnimation:(BOOL)flag shakeNumber:(NSInteger)number
{
    if (self.dataCaches.count) {
        id<PresentModelAble> obj = self.dataCaches.firstObject;
        NSArray *objs = [self subarrayWithObj:obj];
        __weak typeof(self) ws = self;
        [cell showAnimationWithModel:obj showShakeAnimation:YES prepare:^{
            if ([ws.delegate respondsToSelector:@selector(presentView:configCell:sender:giftName:)]) {
                [ws.delegate presentView:ws configCell:cell sender:[obj sender] giftName:[obj giftName]];
            }
        } completion:^(BOOL flag) {
            if (flag) {
                [cell shakeAnimationWithNumber:objs.count];
            }
        }];
    }else if (self.nonshakeDataCaches.count) {
        //带连乘的缓存优先处理
        [self insertNonshakeAnimationMessages:nil];
    }else {
        [cell releaseVariable];
    }
}

@end

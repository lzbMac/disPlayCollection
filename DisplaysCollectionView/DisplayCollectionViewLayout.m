//
//  DisplayCollectionViewLayout.m
//  DisplaysCollectionView
//
//  Created by 李正兵 on 16/4/18.
//  Copyright © 2016年 李正兵. All rights reserved.
//

#import "DisplayCollectionViewLayout.h"

#define INTERSPACE 0.65

static const NSInteger visibleCount = 5;

@interface DisplayCollectionViewLayout()
{
    CGFloat _viewHeight;
    CGFloat _itemHeight;
}

@end

@implementation DisplayCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    _viewHeight = CGRectGetWidth(self.collectionView.frame);
    _itemHeight = self.itemSize.width;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight - _itemHeight)/2, 0, (_viewHeight - _itemHeight)/2);
        
}

- (CGSize)collectionViewContentSize {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    return CGSizeMake(cellCount * _itemSize.width, CGRectGetHeight(self.collectionView.frame));
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY = self.collectionView.contentOffset.x + _viewHeight / 2;
    NSInteger index = centerY / _itemHeight;
    NSInteger count = (visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    
    CGFloat cY = self.collectionView.contentOffset.x + _viewHeight / 2;
    CGFloat attributesY = _itemHeight * indexPath.row + _itemHeight / 2;
    attributes.zIndex = -ABS(attributesY - cY);
    
    CGFloat delta = cY - attributesY;
    CGFloat ratio =  - delta / (_itemHeight * 2);
    CGFloat scale = 1 - ABS(delta) / (_itemHeight * 6.0) * cos(ratio * M_PI_4);
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat centerY = attributesY;
    
    attributes.center = CGPointMake(centerY, CGRectGetHeight(self.collectionView.frame) / 2);
    
    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf((proposedContentOffset.x + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
    proposedContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    return proposedContentOffset;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}

@end

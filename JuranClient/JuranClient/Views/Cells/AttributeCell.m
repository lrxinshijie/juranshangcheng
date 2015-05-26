//
//  AttributeCell.m
//  JuranClient
//
//  Created by 李 久龙 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "AttributeCell.h"
#import "AttributeLabelCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "TagCollectionViewCell.h"
#import "ProductDetailViewController.h"

@interface AttributeCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    TagCollectionViewCell *_sizingCell;
}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *attrList;

@end

@implementation AttributeCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _collectionView.delegate = nil; _collectionView.dataSource = nil;
}

- (void)awakeFromNib {
    // Initialization code
//    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];

    UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCell"];
    
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = _attrList[indexPath.row];
    cell.label.text = string;
}

- (void)fillCellWithDict:(NSDictionary *)dict{
    _nameLabel.text = [dict getStringValueForKey:@"attrName" defaultValue:@""];
    self.attrList = [dict getArrayValueForKey:@"attrList" defaultValue:nil];
    [_collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
        NSInteger height = _collectionView.collectionViewLayout.collectionViewContentSize.height + 49;
        if (height < [AttributeCell cellHeight]) {
            height = [AttributeCell cellHeight];
        }
        if ([_viewController.attributeHeights[_indexPath.row] integerValue] != height) {
            
            [_viewController.attributeHeights replaceObjectAtIndex:_indexPath.row withObject:@(height)];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameAttributeRowReload object:_indexPath];
        }
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_attrList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    BOOL isEnable = [_viewController.product attirbuteIsEnable:_viewController.attributeSelected fromRow:_viewController.fromRow toIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:_indexPath.row]];
    
    cell.isEnable = isEnable;

    cell.isSelect = indexPath.row == [_viewController.attributeSelected[_indexPath.row] integerValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:_sizingCell forIndexPath:indexPath];
    
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TagCollectionViewCell *cell = (TagCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.isEnable) {
        return;
    }
    
    NSInteger value = [[_viewController.attributeSelected objectAtIndex:_indexPath.row] integerValue];
    if (value == indexPath.row) {
        [_viewController.attributeSelected replaceObjectAtIndex:_indexPath.row withObject:@(-1)];
    }else{
        [_viewController.attributeSelected replaceObjectAtIndex:_indexPath.row withObject:@(indexPath.row)];
    }
    
    [_viewController reloadPrice:_indexPath.row];
}

+ (CGFloat)cellHeight{
    return 79;
}

@end

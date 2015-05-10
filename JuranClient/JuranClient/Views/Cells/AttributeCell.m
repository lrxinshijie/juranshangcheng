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

@interface AttributeCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    TagCollectionViewCell *_sizingCell;
}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *attrList;
@end

@implementation AttributeCell

- (void)awakeFromNib {
    // Initialization code
    
    _collectionView.backgroundColor = [UIColor clearColor];
//    UINib *cellNib = [UINib nibWithNibName:@"AttributeLabelCell" bundle:nil];
//    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AttributeLabelCell"];
    
//    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([TagCollectionViewCell class]) bundle:nil];
//    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:NSStringFromClass([TagCollectionViewCell class])];
    
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
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_attrList count];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor = [UIColor redColor];
    
    [(TagCollectionViewCell *)cell setIsSelect:indexPath.row == [_attributeSelected[_indexPath.row] integerValue]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TagCollectionViewCell class]) forIndexPath:indexPath];
//    [cell fillCellWithData:_attrList[indexPath.row]];
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
//    cell.isSelect = indexPath.row == [_attributeSelected[_indexPath.row] integerValue];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:_sizingCell forIndexPath:indexPath];
    
    return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
//    return CGSizeMake(85, 25);
//    
//    NSString *title = _attrList[indexPath.row];
//    CGSize size = [AttributeLabelCell cellSizeWithTitle:title];
//    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger value = [[_attributeSelected objectAtIndex:_indexPath.row] integerValue];
    if (value == indexPath.row) {
        [_attributeSelected replaceObjectAtIndex:_indexPath.row withObject:@(-1)];
    }else{
        [_attributeSelected replaceObjectAtIndex:_indexPath.row withObject:@(indexPath.row)];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameProudctPriceReloadData object:nil];
}

+ (CGFloat)cellHeight{
    return 79;
}

@end

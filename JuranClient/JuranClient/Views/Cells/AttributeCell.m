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

@interface AttributeCell () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>{
    AttributeLabelCell *_sizingCell;
}

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *attrList;
@end

@implementation AttributeCell

- (void)awakeFromNib {
    // Initialization code
    
    _collectionView.backgroundColor = [UIColor clearColor];
    UINib *cellNib = [UINib nibWithNibName:@"AttributeLabelCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"AttributeLabelCell"];
    
    _sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    cell.backgroundColor = [UIColor redColor];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttributeLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeLabelCell" forIndexPath:indexPath];
    [cell fillCellWithData:_attrList[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = _attrList[indexPath.row];
    CGSize size = [AttributeLabelCell cellSizeWithTitle:title];
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

+ (CGFloat)cellHeight{
    return 77;
}

@end

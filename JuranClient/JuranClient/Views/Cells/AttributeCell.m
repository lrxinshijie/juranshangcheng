//
//  AttributeCell.m
//  JuranClient
//
//  Created by 李 久龙 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "AttributeCell.h"
#import "AttributeLabelCell.h"

@interface AttributeCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *attributeValues;
@end

@implementation AttributeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithDict:(NSDictionary *)dict{
    _nameLabel.text = [dict getStringValueForKey:@"attributeName" defaultValue:@""];
    self.attributeValues = [dict getArrayValueForKey:@"attributeValues" defaultValue:nil];
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_attributeValues count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AttributeLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AttributeLabelCell" forIndexPath:indexPath];
    [cell fillCellWithData:_attributeValues[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

+ (CGFloat)cellHeight{
    return 77;
}

@end

//
//  ShopCollectionCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopCollectionCell.h"
#import "JRShop.h"

@interface ShopCollectionCell()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UIButton *collectionButton;

@property (nonatomic, strong) JRShop *shop;

@end

@implementation ShopCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithValue:(JRShop*)shop{
    self.shop = shop;
    _nameLabel.text = shop.shopName;
    [_collectionButton setImage:[UIImage imageNamed:_shop.isStored?@"icon-collection-active.png":@"icon-collection.png"] forState:UIControlStateNormal];
}

- (IBAction)onCollection:(id)sender{
    [_shop collectionWithViewCotnroller:self.viewController finishBlock:^{
        [_collectionButton setImage:[UIImage imageNamed:_shop.isStored?@"icon-collection-active.png":@"icon-collection.png"] forState:UIControlStateNormal];
    }];
}

@end

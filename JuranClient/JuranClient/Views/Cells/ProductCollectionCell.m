//
//  ProductCollectionCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/26.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ProductCollectionCell.h"
#import "NaviStoreListViewController.h"
#import "JRProduct.h"
#import "JRStore.h"

@interface ProductCollectionCell()

@property (nonatomic, strong) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UIButton *collectionButton;
@property (nonatomic, strong) IBOutlet UIView *addressView;

@property (nonatomic, strong) JRProduct *product;

@end

@implementation ProductCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithValue:(JRProduct*)product{
    self.product = product;
    
    _nameLabel.text = product.goodsName;
    [_imgView setImageWithURLString:product.defaultImage];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@", product.onSaleMinPrice];
    [_collectionButton setImage:[UIImage imageNamed:product.type?@"icon-collection-active.png":@"icon-collection.png"] forState:UIControlStateNormal];
    
    if (product.stallInfoList.count > 0) {
        JRStore *s = product.stallInfoList.firstObject;
        _addressLabel.text = s.stallName;
        _addressView.hidden = NO;
    }else{
        _addressView.hidden = YES;
    }
}

- (IBAction)onCollection:(id)sender{
    [_product favority:^(BOOL result) {
        [_collectionButton setImage:[UIImage imageNamed:_product.type?@"icon-collection-active.png":@"icon-collection.png"] forState:UIControlStateNormal];
    }];
}

- (IBAction)onLocation:(id)sender{
    NaviStoreListViewController *navi = [[NaviStoreListViewController alloc]init];
    navi.naviType = NaviTypeStall;
    navi.dataList = _product.stallInfoList;
    navi.navigationItem.title = @"店铺位置";
    [self.viewController.navigationController pushViewController:navi animated:YES];
}

@end

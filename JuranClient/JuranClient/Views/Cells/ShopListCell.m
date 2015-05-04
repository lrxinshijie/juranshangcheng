//
//  ShopListCell.m
//  JuranClient
//
//  Created by 彭川 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopListCell.h"
#import "JRShop.h"
#import "NaviStoreListViewController.h"
#import "JRStore.h"
#import "AppDelegate.h"
#import "UserLocation.h"

@interface ShopListCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelMainBrand;
@property (strong, nonatomic) IBOutlet UIButton *btnNavi;
@property (strong, nonatomic) IBOutlet UIImageView *imageGrade;
@property (assign, nonatomic) NSInteger shopId;
@property (strong, nonatomic) NSArray *dataList;
@end

@implementation ShopListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)fillCellWithJRShop:(JRShop *)shop {
    _labelName.text = shop.shopName;
    [_labelName sizeToFit];
    CGRect frame = _labelName.frame;
    frame.size.width = _labelName.frame.size.width<150?_labelName.frame.size.width:150;
    _labelName.frame = frame;
    frame = _imageGrade.frame;
    frame.origin.x = _labelName.frame.origin.x + _labelName.frame.size.width + 5;
    _imageGrade.frame = frame;
    if ([shop.grade isEqual:@"0"]) {
        _imageGrade.image = [UIImage imageNamed:@"icon-grade-1.png"];
    }else if ([shop.grade isEqual:@"1"])  {
        _imageGrade.image = [UIImage imageNamed:@"icon-grade-2.png"];
    }
    _labelMainBrand.text = [NSString stringWithFormat:@"主营品牌:%@",shop.brands];
    [_labelMainBrand sizeToFit];
    [_imageLogo setImageWithURLString:shop.logo];
    _shopId = shop.shopId;
    [_btnNavi addTarget:self action:@selector(btnNaviClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)loadData{
#ifndef kJuranDesigner
    NSDictionary *param = @{@"shopId": @(_shopId),@"cityName":ApplicationDelegate.gLocation.cityName};
    [self.viewController showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_LOCATION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self.viewController hideHUD];
        if (!error) {
            if (data!=[NSNull null]) {
                _dataList = [JRStore buildUpWithValueForList:[data objectForKey:@"stallInfoList"]];
            }
            NaviStoreListViewController *navi = [[NaviStoreListViewController alloc]init];
            navi.naviType = NaviTypeStall;
            navi.dataList = _dataList;
            navi.navigationItem.title = @"店铺位置";
            [self.viewController.navigationController pushViewController:navi animated:YES];
        }
    }];
#endif
}


- (void)btnNaviClick:(id)sender {
    [self loadData];
}
@end

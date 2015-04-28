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

@interface ShopListCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelMainBrand;
@property (strong, nonatomic) IBOutlet UIButton *btnNavi;
@property (strong, nonatomic) IBOutlet UIImageView *imageGrade;
@property (assign, nonatomic) NSInteger shopId;
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
    frame.size.width = _labelName.frame.size.width<155?_labelName.frame.size.width:155;
    _labelName.frame = frame;
    frame = _imageGrade.frame;
    frame.origin.x = _labelName.frame.origin.x + _labelName.frame.size.width + 5;
    _imageGrade.frame = frame;
    //_imageGrade.image = nil;
    _labelMainBrand.text = [NSString stringWithFormat:@"主营品牌:%@",shop.brands];
    [_labelMainBrand sizeToFit];
    [_imageLogo setImageWithURLString:shop.logo];
    _btnNavi.tag = shop.shopId;
    [_btnNavi addTarget:self action:@selector(btnNaviClick:) forControlEvents:UIControlEventTouchUpInside];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)loadData{
    NSDictionary *param = @{@"shopId": @(_shopId)};
    [self.viewController showHUD];
    [[ALEngine shareEngine] pathURL:JR_SHOP_LOCATION parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self.viewController hideHUD];
        if (!error) {
            
        }
    }];
}


- (void)btnNaviClick:(id)sender {
#ifndef kJuranDesigner
    NaviStoreListViewController *navi = [[NaviStoreListViewController alloc]init];
    [self.viewController.navigationController pushViewController:navi animated:YES];
#endif
}
@end

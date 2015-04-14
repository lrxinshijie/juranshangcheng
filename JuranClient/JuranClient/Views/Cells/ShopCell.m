//
//  ShopCell.m
//  JuranClient
//
//  Created by HuangKai on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ShopCell.h"

@interface ShopCell()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UIImageView *defaultImageView;

@end

@implementation ShopCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)fillCellWithValue:(id)value{
    if (!value || ![value isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.nameLabel.text = [value getStringValueForKey:@"productName" defaultValue:@""];
    [self.defaultImageView setImageWithURLString:[value getStringValueForKey:@"defaultImage" defaultValue:@""]];
    self.priceLabel.text = [value getStringValueForKey:@"onSaleMinPrice" defaultValue:@""];
}

@end

//
//  ShopListCell.h
//  JuranClient
//
//  Created by 彭川 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageLogo;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelMainBrand;
@property (strong, nonatomic) IBOutlet UIButton *btnNavi;
@end

//
//  CustomShopView.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CustomBrandView.h"

@interface CustomBrandView ()
@property (strong, nonatomic) IBOutlet UIImageView *lImage;
@property (strong, nonatomic) IBOutlet UILabel *lText;
@property (strong, nonatomic) IBOutlet UIImageView *rImage;
@property (strong, nonatomic) IBOutlet UILabel *rtext;
@property (strong, nonatomic) IBOutlet UIButton *lbtn;
@property (strong, nonatomic) IBOutlet UIButton *rbtn;

@end

@implementation CustomBrandView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)configViewUIWithItem:(ShopViewItem *)item
{
    if (item.lText.length != 0 && item.lText) {
        self.lImage.hidden = NO;
        self.lText.hidden = NO;
        self.lbtn.hidden = NO;
        [self.lImage setImageWithURLString:item.lImageURL];
        self.lText.text = item.lText;
    }else{
        self.lImage.hidden = YES;
        self.lText.hidden = YES;
        self.lbtn.hidden = YES;
    }
    if (item.rText.length != 0 && item.rText) {
        self.rImage.hidden = NO;
        self.rtext.hidden = NO;
        self.rbtn.hidden = NO;
        [self.rImage setImageWithURLString:item.rImageURL];
        self.rtext.text = item.rText;
    }else{
        self.rImage.hidden = YES;
        self.rtext.hidden = YES;
        self.rbtn.hidden = YES;
    }
}

- (IBAction)buttonDidClick:(id)sender {
    //6000
    
    UIButton * button = (UIButton *)sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopViewItemDidClickAtIndex:)]) {
        [self.delegate shopViewItemDidClickAtIndex:button.tag-6000];
    }
    
}


@end

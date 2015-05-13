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

@property (strong, nonatomic) NSString * lcode;
@property (strong, nonatomic) NSString * rcode;

@property (assign, nonatomic) long lid;
@property (assign, nonatomic) long rid;

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
        self.lcode = [NSString stringWithFormat:@"%@",item.lcode];
        self.lid = item.lid;
        
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
        self.rcode = [NSString stringWithFormat:@"%@",item.rcode];
        self.rid = item.rid;
        
    }else{
        self.rImage.hidden = YES;
        self.rtext.hidden = YES;
        self.rbtn.hidden = YES;
    }
}

- (IBAction)buttonDidClick:(id)sender {
    //6000
    
    UIButton * button = (UIButton *)sender;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopViewItemDidClickWithCode:Name:ID:)]) {
        if (button.tag == 6000) {
            [self.delegate shopViewItemDidClickWithCode:self.lcode Name:self.lText.text ID:self.lid];
        }else{
            [self.delegate shopViewItemDidClickWithCode:self.rcode Name:self.rtext.text ID:self.rid];
        }
    }
    
}


@end

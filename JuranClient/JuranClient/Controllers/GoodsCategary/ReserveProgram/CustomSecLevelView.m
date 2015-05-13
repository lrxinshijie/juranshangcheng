//
//  CustomSecLevelView.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CustomSecLevelView.h"

@interface CustomSecLevelView ()


@property (strong, nonatomic) IBOutlet UIImageView *lImage;
@property (strong, nonatomic) IBOutlet UIImageView *mImage;
@property (strong, nonatomic) IBOutlet UIImageView *rImage;
@property (strong, nonatomic) IBOutlet UILabel *lLabel;
@property (strong, nonatomic) IBOutlet UILabel *mLabel;
@property (strong, nonatomic) IBOutlet UILabel *rLabel;
@property (strong, nonatomic) NSString * lRequestID;
@property (strong, nonatomic) NSString * mRequestID;
@property (strong, nonatomic) NSString * rRequestID;
@property (strong, nonatomic) IBOutlet UIImageView *selectBGImage;

@property (strong, nonatomic) NSMutableArray * dataArray;
//进行排序之后重做的二维数组
@property (strong, nonatomic) NSMutableArray * finalDataArray;

@property (assign, nonatomic) struct SelectLocation old_loc;

@end


@implementation CustomSecLevelView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)initSecondLevelViewWithItem:(SecondLevelItem *)item
{
    [self.lImage setImageWithURLString:item.lImage];
    self.lLabel.text = item.lText;
    self.lRequestID = item.lID;
    if ((!item.lID || item.lID.length==0) && (!item.lImage || item.lImage.length==0) && (!item.lText || item.lText.length==0)) {
        self.lImage.hidden = YES;
        self.lLabel.hidden = YES;
    }else{
        self.lImage.hidden = NO;
        self.lLabel.hidden = NO;
    }
    
    [self.mImage setImageWithURLString:item.mImage];
    self.mLabel.text = item.mText;
    self.mRequestID = item.mID;
    if ((!item.mID || item.mID.length==0) && (!item.mImage || item.mImage.length==0) && (!item.mText || item.mText.length==0)) {
        self.mImage.hidden = YES;
        self.mLabel.hidden = YES;
    }else{
        self.mImage.hidden = NO;
        self.mLabel.hidden = NO;
    }
    
    [self.rImage setImageWithURLString:item.rImage];
    self.rLabel.text = item.rText;
    self.rRequestID = item.rID;
    if ((!item.rID || item.rID.length==0) && (!item.rImage || item.rImage.length==0) && (!item.rText || item.rText.length==0)) {
        self.rImage.hidden = YES;
        self.rLabel.hidden = YES;
    }else{
        self.rImage.hidden = NO;
        self.rLabel.hidden = NO;
    }
    
    //首先下边的尖角选择的灰色图片隐藏
    self.selectBGImage.hidden = !item.isSelect;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.finalDataArray = [NSMutableArray arrayWithCapacity:0];
    [self setSelectImage:item.selectLocation];
    
    //配置字体颜色，因为此View是作为TableView的section的header加载的，每次刷新会不作处理的话字体颜色就会默认成xib设置的黑色。
    if (item.lColor) {
        self.lLabel.textColor = item.lColor;
    }
    if (item.mColor) {
        self.mLabel.textColor = item.mColor;
    }
    if (item.rColor) {
        self.rLabel.textColor = item.rColor;
    }
}

- (IBAction)didSelect:(UIButton *)sender {
    //6101、6102、6103
    struct SelectLocation loc;
    loc.viewNum = self.tag;
    NSString * req_ID;
    switch (sender.tag-6100) {
        case 1:
            loc.index = Location_Left;
            req_ID = self.lRequestID;
            break;
        case 2:
            loc.index = Location_Middle;
            req_ID = self.mRequestID;
            break;
        case 3:
            loc.index = Location_Right;
            req_ID = self.rRequestID;
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondLevelView:didClickAtIndex:requestID:)]) {
        [self.delegate secondLevelView:self didClickAtIndex:loc requestID:req_ID];
    }
    
    self.old_loc = loc;
}


- (void)setTextSelectColor:(Location)loc
{
    if (loc == Location_Left) {
        self.lLabel.textColor = [UIColor colorWithRed:11.0/255.0 green:81.0/255.0 blue:168.0/255.0 alpha:1.0];
    }else if (loc == Location_Middle){
        self.mLabel.textColor = [UIColor colorWithRed:11.0/255.0 green:81.0/255.0 blue:168.0/255.0 alpha:1.0];
    }else if (loc == Location_Right){
        self.rLabel.textColor = [UIColor colorWithRed:11.0/255.0 green:81.0/255.0 blue:168.0/255.0 alpha:1.0];
    }
}

- (void)setTextNormalColor:(Location)loc
{
    if (loc == Location_Left) {
        self.lLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }else if (loc == Location_Middle){
        self.mLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }else if (loc == Location_Right){
        self.rLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}

- (void)setSelectImage:(Location)loc
{
    
    switch (loc) {
        case Location_Left:
            
            self.selectBGImage.image = [UIImage imageNamed:@"third_bg_header_left"];
            
            break;
        case Location_Middle:
            
            self.selectBGImage.image = [UIImage imageNamed:@"third_bg_header_middle"];
            
            break;
        case Location_Right:
            
            self.selectBGImage.image = [UIImage imageNamed:@"third_bg_header_right"];
            
            break;
        case Location_None:
            
            self.selectBGImage.image = [UIImage imageNamed:@""];
            
            break;
        default:
            break;
    }
}





@end

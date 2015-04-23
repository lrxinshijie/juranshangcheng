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
    //TODO:需要检测item是不是左中右三个都有参数，然后配置UI，此处等接口
    
    
    
    //首先下边的尖角选择的灰色图片隐藏
    self.selectBGImage.hidden = !item.isSelect;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.finalDataArray = [NSMutableArray arrayWithCapacity:0];
    [self setSelectImage:item.selectLocation];
}

- (IBAction)didSelect:(UIButton *)sender {
    //6101、6102、6103
    struct SelectLocation loc;
    loc.viewNum = self.tag;
    switch (sender.tag-6100) {
        case 1:
            loc.index = Location_Left;
            break;
        case 2:
            loc.index = Location_Middle;
            break;
        case 3:
            loc.index = Location_Right;
            break;
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondLevelView:didClickAtIndex:)]) {
        [self.delegate secondLevelView:self didClickAtIndex:loc];
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

//
//  CustomThirdLevelCell.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/21.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "CustomThirdLevelCell.h"
#import "DataItem.h"

@interface CustomThirdLevelCell ()

@property (strong, nonatomic) NSMutableArray * array;
@property (strong, nonatomic) DataItem * dItem;

@end

@implementation CustomThirdLevelCell

- (void)awakeFromNib {
    // Initialization code
    if (!self.array) {
        self.array = [NSMutableArray arrayWithCapacity:0];
    }
}

- (void)dynamicCreateUIWithData:(NSArray *)arr
{
    [self removeAllSubView];
    //记录下一个label的x的位置
    int lastLabelLoc = 15;
    for (int i = 0; i<arr.count; i++) {
        
        DataItem * item = arr[i];
        
        NSString * str = item.name;
        int lWidth = str.length*11;
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(lastLabelLoc, 15, lWidth, 11)];
        lastLabelLoc += (lWidth+20);
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = str;
        
        CustomButton * button = [CustomButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = label.frame;
        frame.origin.y = 0;
        frame.size.height = 31;
        button.frame = frame;
        //TODO:此处要把需要传参的内容付给Button，用于以后传参使用。
        [button setCatName:item.name];
        [button setCatCode:item.categoryCode];
        [button setParentCode:item.isOrNoFatherNode];
        [button setUrlContent:item.urlContent];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(buttonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:button];
        
        [self.array addObject:label];
        [self.array addObject:button];
    }
}

- (void)removeAllSubView
{
    for (int i=0; i<self.array.count; i++) {
        UIView * view = [self.array objectAtIndex:i];
        [view removeFromSuperview];
    }
    [self.array removeAllObjects];
}

- (void)addLine
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 243, 1)];
    view.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.contentView addSubview:view];
    [self.array addObject:view];
}

- (void)buttonDidSelect:(UIButton *)button
{
    CustomButton * cButton = (CustomButton *)button;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(thirdLevelItemDidSelectedWithCatCode:CatName:ParentCode:UrlContent:)]) {
        [self.delegate thirdLevelItemDidSelectedWithCatCode:cButton.catCode CatName:cButton.catName ParentCode:cButton.parentCode UrlContent:cButton.urlContent];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

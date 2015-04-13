//
//  SearchTableViewCell.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/11.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (assign, nonatomic) SearchTableViewCellModel style;

@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//此处可能需要一个ID，用来表示搜索类型。待接口商定。
- (void)setCellUIWithCellModel:(SearchTableViewCellModel)model leftLabelText:(NSString *)name rightLabelText:(NSString *)count
{
    self.style = model;
    
    if (model == SearchTableViewCellModel_History) {
        
        self.nameLabel.hidden = NO;
        self.countLabel.hidden = YES;
        
        self.nameLabel.text = name;
        self.countLabel.text = nil;
        
    }else if (model == SearchTableViewCellModel_SearchRange){
        
        self.nameLabel.hidden = NO;
        self.countLabel.hidden = NO;
        
        self.nameLabel.text = name;
        self.countLabel.text = [NSString stringWithFormat:@"%@个结果",count];
        
    }
    
}

- (NSString *)getSearchCellMessage
{
    NSString * tempStr;
    if (self.style == SearchTableViewCellModel_History) {
        tempStr = self.nameLabel.text;
    }else if (self.style == SearchTableViewCellModel_SearchRange){
        //TODO:此处应该返回表示搜索范围的标示，待接口商定.
        tempStr = self.nameLabel.text;
    }
    return tempStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SecondLevelView.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/14.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "SecondLevelView.h"

@interface SecondLevelView ()

@property (strong, nonatomic) IBOutlet UIImageView *leftImage;
@property (strong, nonatomic) IBOutlet UIImageView *middleImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightImage;

@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *middleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation SecondLevelView

- (void)configViewUIWithArray:(NSArray *)arr
{
    [self setViewInitialHeight];
    //从左开始编号为1号
    //TODO:需要处理排序的问题，即当第一个数据为空的时候，顺延。
    [self.leftImage setImageWithURLString:[[arr objectAtIndex:0] objectForKey:@"image"]];
    [self.middleImage setImageWithURLString:[[arr objectAtIndex:1] objectForKey:@"image"]];
    [self.rightImage setImageWithURLString:[[arr objectAtIndex:2] objectForKey:@"image"]];
    
    self.leftLabel.text = [[arr objectAtIndex:0] objectForKey:@"name"];
    self.middleLabel.text = [[arr objectAtIndex:1] objectForKey:@"name"];
    self.rightLabel.text = [[arr objectAtIndex:2] objectForKey:@"name"];
    
}

- (void)setViewInitialHeight
{
    CGRect frame = self.frame;
    frame.size.height = 95;
    self.frame = frame;
}

- (void)showThirdLevelView
{
    
}

- (int)placeThirdLevelItemWithArray:(NSArray *)arr
{
    int tempHeight = 0;
    
    int tailLocation = 0;
    for (int i=0; i<arr.count; i++) {
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10];
        label.backgroundColor = [UIColor clearColor];
        label.text = arr[i];
        int length = label.text.length*10;
        //初始化一个坐标，用于动态计算label的x和width
        CGRect labelFrame = CGRectMake(0, 30 + (i/3)*40, length, 10);
        if (tailLocation == 0) {
            
            labelFrame.origin.x = 10;
            
            if (length + 10 >= 90) {
                tailLocation = 2;
            }else{
                tailLocation = 1;
            }
            
            //tempHeight加一，用于最后返回当前View的高度
            tempHeight += 1;
            
        }else if (tailLocation == 1){
            
            labelFrame.origin.x = 110;
            
            if (length + 110 >= 190) {
                tailLocation = 0;
            }else{
                tailLocation = 2;
            }
            
        }else if (tailLocation == 2){
            
            tailLocation = 0;
            
            if (length + 210 > 250) {
                labelFrame.origin.x = 210;
            }else{
                labelFrame.origin.x = 10;
            }
            
        }
        
    }
    
    return tempHeight*40;
}

- (IBAction)secondLevelItemDidSelect:(id)sender {
    
    //6000为左边按钮，6001为中间按钮，6002为右边按钮
    
}


@end

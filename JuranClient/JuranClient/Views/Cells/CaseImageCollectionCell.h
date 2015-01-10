//
//  CaseImageCollectionCell.h
//  JuranClient
//
//  Created by HuangKai on 15/1/3.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseImageCollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

- (void)setImage:(UIImage*)image;

@end

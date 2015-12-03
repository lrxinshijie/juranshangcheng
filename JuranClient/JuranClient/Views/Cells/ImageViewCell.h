//
//  ImageViewCell.h
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomInImageView.h"

@protocol ImageViewCellDelete <NSObject>

-(void)addPhoto:(UIButton *)btnDelete;
-(void)deletePhoto:(UIButton *)btnDelete ZoomInImageView:(ZoomInImageView *)imageView;

@end

@interface ImageViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet ZoomInImageView *zoomimageView;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnAddClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic,assign) id<ImageViewCellDelete> delegate;
-(void)setImage:(NSString *)str;

@end

//
//  ImageViewCell.m
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ImageViewCell.h"
#import "ALGetPhoto.h"
#import "UIImageView+WebCache.h"


@implementation ImageViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImageViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    _btnDelete.hidden=YES;
    _zoomimageView.contentMode=UIViewContentModeScaleAspectFill;
   
    _zoomimageView.clipsToBounds=YES;
    [_btnDelete setExclusiveTouch:YES];
    [_addBtn setExclusiveTouch:YES];
        // Initialization code
}

- (IBAction)btnDeleteClick:(id)sender {
    if(_delegate &&[_delegate respondsToSelector:@selector(deletePhoto:ZoomInImageView:)])
    {
        [_delegate deletePhoto:_btnDelete ZoomInImageView:_zoomimageView];
    }
    
    
}

-(void)setImage:(NSString *)str
{
    _zoomimageView.contentMode=UIViewContentModeScaleAspectFill;

    if([str isEqualToString:@"image_addDefault.png"])
    {
        _zoomimageView.image=[UIImage imageNamed:@"image_addDefault.png"];
        _btnDelete.hidden=YES;
    }
    else
    {
        
        
        [_zoomimageView sd_setImageWithURL:[Public imageURL:[NSString stringWithFormat:@"%@_280_140.img",str] ]];
        _zoomimageView.url=str;
//        [_zoomimageView setImageWithURLString:@"http://image10.juran.cn/img/5652da42e4b07d88ca907505.img_140_140.img"];
        _btnDelete.hidden=NO;

    }
}

- (IBAction)btnAddClick:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(addPhoto:)])
    {
        [_delegate addPhoto:_btnDelete];
    }
    
//    [[ALGetPhoto sharedPhoto] showInViewController:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
//           }];

    
//    _btnDelete.hidden=NO;
}
@end

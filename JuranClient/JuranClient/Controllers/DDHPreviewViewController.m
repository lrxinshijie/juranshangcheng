//
//  DDHPreviewViewController.m
//  DiDiHu
//
//  Created by Sean on 14-6-25.
//  Copyright (c) 2014年 GLSX. All rights reserved.
//

#import "DDHPreviewViewController.h"
#import "UIImageView+WebCache.h"
#import "ZoomInImageView.h"

@interface DDHPreviewViewController ()<UIScrollViewDelegate>{
    
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DDHPreviewViewController

- (void)dealloc{
    _scrollView.delegate = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor=[UIColor blackColor];
   
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    [self.view addSubview:_scrollView];

    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _imageView.userInteractionEnabled=YES;
   
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_imageView addGestureRecognizer:tap];
    [_scrollView addSubview:_imageView];
    
    UILabel *label = [self.view labelWithFrame:CGRectMake(0, CGRectGetHeight(_imageView.frame)-80, CGRectGetWidth(_imageView.frame), 80) text:@"" textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    label.numberOfLines=0;
    NSString *imageStr = [_url stringByAppendingString:@"_512_0.img"];

    [_imageView setImageWithURL:[Public imageURL:imageStr] placeholderImage:[UIImage imageNamed:@"case_default_image.png"]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



@end

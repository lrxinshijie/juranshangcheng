//
//  UploadCardImageViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/2.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "UploadCardImageViewController.h"
#import "ALGetPhoto.h"
#import "CanRemoveImageView.h"

@interface UploadCardImageViewController ()<CanRemoveImageViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIButton *chooseButton1;
@property (nonatomic, strong) IBOutlet UILabel *chooseLabel1;

@property (nonatomic, strong) IBOutlet UIButton *chooseButton2;
@property (nonatomic, strong) IBOutlet UILabel *chooseLabel2;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) NSArray *tips;

@end

@implementation UploadCardImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"上传证件照片";
    
    self.tips = @[@"两款手机分离开谁开的房间", @"了手机福利时间了"];
    
    [self setupUI];
}

- (void)setupUI{
    CGRect frame = _contentView.frame;
    frame.origin = CGPointMake(0, 0);
    _contentView.frame = frame;
    [self.view addSubview:_contentView];
    
    frame = CGRectMake(15, CGRectGetMaxY(_contentView.frame), kWindowWidth -30, 0);
    self.tipsLabel = [self.view labelWithFrame:frame text:@"111" textColor:RGBColor(66, 103, 177) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:kSystemFontSize]];
    self.tipsLabel.numberOfLines = 0;
    [self.view addSubview:_tipsLabel];
    
    _chooseButton1.hidden = _chooseButton2.hidden = _chooseLabel1.hidden = _chooseLabel2.hidden = NO;
    if (_type) {
        _chooseLabel1.text = @"正面";
        _tipsLabel.text = _tips[0];
    }else if (_type == 1){
        _chooseLabel2.hidden = _chooseButton2.hidden = YES;
        _chooseLabel1.text = @"手持证件照片";
        _tipsLabel.text = _tips[1];
    }
    
    frame = _tipsLabel.frame;
    frame.size.height = [_tipsLabel.text heightWithFont:_tipsLabel.font constrainedToWidth:CGRectGetWidth(_tipsLabel.frame)];
    _tipsLabel.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onChooseImage:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:btn.frame];
        [imageView setImage:images.firstObject];
        imageView.delegate = self;
        [btn.superview addSubview:imageView];
    }];
}

#pragma CanRemoveImageView

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    
}

@end

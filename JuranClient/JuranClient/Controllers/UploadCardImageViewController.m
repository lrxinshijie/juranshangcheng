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
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave:) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:[[ALTheme sharedTheme] navigationButtonColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tips = @[@"备注：\n·请使用扫描、数码拍摄、复印得到的真实身份证有效图片上传来进行实名认证；\n·仅支持二代身份证，要求姓名、证件号码、脸部、地址清晰可见；\n·支持上传图片类型：JPG/PNG/BMP，文件大小在5M以内。", @"备注：\n·免冠、建议未化妆；五官可见；\n·身份证全部信息需清晰无遮挡，否则认证将无法通过；\n·完整露出手臂；\n·请勿进行任何软件处理；\n·支持上传图片类型：JPG/PNG/BMP，文件大小在10M以内。"];
    
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
    if (_type == 0) {
        _chooseLabel1.text = @"正面";
        _tipsLabel.text = _tips[0];
        if (self.positiveIdImage) {
            CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:_chooseButton1.frame];
            [imageView setImage:_positiveIdImage];
            imageView.delegate = self;
            [_chooseButton1.superview addSubview:imageView];
            imageView.tag = 0;

        }
        if (self.backIdImage){
            CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:_chooseButton2.frame];
            [imageView setImage:_backIdImage];
            imageView.delegate = self;
            [_chooseButton2.superview addSubview:imageView];
            imageView.tag = 1;
        }
        
    }else if (_type == 1){
        _chooseLabel2.hidden = _chooseButton2.hidden = YES;
        _chooseLabel1.text = @"手持证件照片";
        _tipsLabel.text = _tips[1];
        
        if (self.headImage){
            CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:_chooseButton1.frame];
            [imageView setImage:_headImage];
            imageView.delegate = self;
            [_chooseButton1.superview addSubview:imageView];
        }
    }
    
    frame = _tipsLabel.frame;
    frame.size.height = [_tipsLabel.text heightWithFont:_tipsLabel.font constrainedToWidth:CGRectGetWidth(_tipsLabel.frame)];
    _tipsLabel.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSave:(id)sender{
    if (_type == 0) {
        if (!self.positiveIdImage) {
            [self showTip:@"请选择证件正面图片"];
            return;
        }
        
        if (!self.backIdImage) {
            [self showTip:@"请选择证件反面图片"];
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(uploadCardImageWithImages:andType:)]) {
            [_delegate uploadCardImageWithImages:@[_positiveIdImage, _backIdImage] andType:_type];
        }
    }else if (_type == 1){
        if (!self.headImage) {
            [self showTip:@"请选择手持证件照片"];
            return;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(uploadCardImageWithImages:andType:)]) {
            [_delegate uploadCardImageWithImages:@[_headImage] andType:_type];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChooseImage:(id)sender{
    UIButton *btn = (UIButton*)sender;
    [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:NO MaxNumber:1 Handler:^(NSArray *images) {
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:btn.frame];
        [imageView setImage:images.firstObject];
        imageView.delegate = self;
        [btn.superview addSubview:imageView];
        
        if (_type == 0) {
            if (btn == _chooseButton1) {
                self.positiveIdImage = images.firstObject;
                imageView.tag = 0;
            }else if (btn == _chooseButton2){
                self.backIdImage = images.firstObject;
                imageView.tag = 1;
            }
        }else if (_type == 1){
            self.headImage = images.firstObject;
        }
    }];
}

#pragma CanRemoveImageView

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    if (_type == 0) {
        if (view.tag == 0) {
            self.positiveIdImage = nil;
        }else if (view.tag == 1){
            self.backIdImage = nil;
        }
    }else if (_type == 1){
        self.headImage = nil;
    }
}

@end

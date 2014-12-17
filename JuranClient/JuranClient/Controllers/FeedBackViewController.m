//
//  FeedBackViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-13.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "FeedBackViewController.h"
#import "ALGetPhoto.h"
#import "CanRemoveImageView.h"

@interface FeedBackViewController ()<CanRemoveImageViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *inputView;
@property (nonatomic, strong) IBOutlet UIView *contactView;
@property (nonatomic, strong) IBOutlet ASPlaceholderTextView *contentTextView;
@property (nonatomic, strong) IBOutlet UITextField *contactTextField;
@property (nonatomic, strong) IBOutlet UIView *chooseView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"问题反馈";
    self.view.backgroundColor = RGBColor(241, 241, 241);
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSend) title:@"发送" backgroundImage:nil];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    
    _contentTextView.placeholder = @"请输入详细的描述";
    _inputView.layer.cornerRadius = 3;
    _contactView.layer.cornerRadius = 3;
    
    CGRect frame = _inputView.frame;
    frame.origin = CGPointMake(10, 10);
    _inputView.frame = frame;
    [self.view addSubview:_inputView];
    
    frame = _contactView.frame;
    frame.origin = CGPointMake(10, CGRectGetMaxY(_inputView.frame) + 5);
    _contactView.frame = frame;
    [self.view addSubview:_contactView];
    
}

- (void)onSend{
    if (!(_contactTextField.text && _contactTextField.text.length > 0)) {
        [self showTip:@"联系方式不能为空!!!"];
        return;
    }
    if (!(_contentTextView.text && _contentTextView.text.length > 0)) {
        [self showTip:@"反馈内容不能为空!!!"];
        return;
    }
    NSDictionary *param = @{@"type":@"iphone",
                            @"contactInfo":_contactTextField.text,
                            @"memo":_contentTextView.text};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_ADD_FEEDBACK parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            
        }
    }];
}

- (IBAction)doChoosseImage:(id)sender{
    [[ALGetPhoto sharedPhoto] showInViewController:self allowsEditing:YES MaxNumber:1 Handler:^(NSArray *images) {
        _chooseView.hidden = YES;
        CanRemoveImageView *imageView = [[CanRemoveImageView alloc] initWithFrame:_chooseView.frame];
        imageView.delegate = self;
        [imageView setImage:images[0]];
        [_inputView addSubview:imageView];
    }];
}

#pragma CanRemoveImageView

- (void)deleteCanRemoveImageView:(CanRemoveImageView *)view{
    _chooseView.hidden = NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_contactTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

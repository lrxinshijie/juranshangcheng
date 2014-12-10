//
//  DetailAddressViewController.m
//  JuranClient
//
//  Created by song.he on 14-12-8.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DetailAddressViewController.h"
#import "JRMemberDetail.h"

@interface DetailAddressViewController ()

@property (nonatomic, strong) IBOutlet UITextView *textVeiw;

@end

@implementation DetailAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"详细地址";
    
    
    UIButton *rightButton = [self.view buttonWithFrame:CGRectMake(0, 0, 60, 30) target:self action:@selector(onSave:) title:@"保存" backgroundImage:nil];
    [rightButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)modifyMemberDetail{
    NSDictionary *param = @{@"detailAddress": _textVeiw.text
                              };
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_EDIT_MEMBERINFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            _memberDetail.detailAddress = _textVeiw.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}


- (void)onSave:(id)sender{
    if (!(_textVeiw.text && _textVeiw.text.length > 0)) {
        return;
    }
    [self modifyMemberDetail];
}

@end

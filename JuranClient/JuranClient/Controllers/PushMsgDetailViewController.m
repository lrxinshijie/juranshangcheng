//
//  PushMsgDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 14/12/30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PushMsgDetailViewController.h"
#import "JRPushInfoMsg.h"

@interface PushMsgDetailViewController ()

@end

@implementation PushMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"消息";
    
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = @{@"msgId": [NSString stringWithFormat:@"%d", _pushInfo.msgId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_MSG_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_pushInfo buildUpDetailWithValue:data];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

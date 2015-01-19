//
//  ActivityDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "JRActivity.h"
#import "ALWebView.h"

@interface ActivityDetailViewController ()<ALWebViewDelegate>

@property (nonatomic, strong) ALWebView *webView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.navigationItem.title = @"精品活动";
    
    self.webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
//    [self loadData];
    
    [_webView loadURLString:[NSString stringWithFormat:@"http://apph5.juran.cn/events/%d", _activity.activityId]];
}

- (void)loadData{
    NSDictionary *param = @{@"id": [NSString stringWithFormat:@"%d", _activity.activityId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ACTIVITY_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_activity buildUpWithValueForDetail:data];
            [self reloadData];
        }
    }];
}

- (void)reloadData{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(ALWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
}

- (void)webViewDidFinishLoad:(ALWebView *)aWebView{
    [self hideHUD];
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

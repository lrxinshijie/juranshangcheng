//
//  QRCodeWebViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "QRCodeWebViewController.h"
#import "ALWebView.h"


@interface QRCodeWebViewController ()<ALWebViewDelegate>

@property (strong, nonatomic) ALWebView * webView;

@end

@implementation QRCodeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [_webView loadURLString:self.requestURL];
}

- (void)webViewDidStartLoad:(ALWebView *)aWebView{
    [self showHUD];
}

- (void)webView:(ALWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
}

- (void)webViewDidFinishLoad:(ALWebView *)aWebView{
    [self hideHUD];
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

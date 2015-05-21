//
//  QRCodeWebViewController.m
//  JuranClient
//
//  Created by 陈晓宁 on 15/5/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "QRCodeWebViewController.h"
#import "ALWebView.h"


@interface QRCodeWebViewController ()<ALWebViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) ALWebView * webView;

@end

@implementation QRCodeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadURLString:self.requestURL];
}

- (void)webViewDidStartLoad:(ALWebView *)aWebView{
    [self showHUD];
}

- (void)webView:(ALWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [self hideHUD];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此链接不支持跳转，点击确认，返回扫一扫。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}

- (void)webViewDidFinishLoad:(ALWebView *)aWebView{
    [self hideHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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

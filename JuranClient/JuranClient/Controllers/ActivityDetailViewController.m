//
//  ActivityDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ALWebView.h"

@interface ActivityDetailViewController ()<ALWebViewDelegate>

@property (nonatomic, strong) ALWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ActivityDetailViewController

- (void)dealloc{
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = _webView.center;
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];
    
    [_webView loadURLString:[NSString stringWithFormat:@"%@?env=uat&fromApp=1", _urlString]];
    
}

- (void)webViewDidStartLoad:(ALWebView *)aWebView{
    [_activityIndicatorView startAnimating];
}

- (void)webView:(ALWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [_activityIndicatorView stopAnimating];
}

- (void)webViewDidFinishLoad:(ALWebView *)aWebView{
    [_activityIndicatorView stopAnimating];
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

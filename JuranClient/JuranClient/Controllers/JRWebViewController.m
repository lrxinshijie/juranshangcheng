//
//  JRWebViewController.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/28.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRWebViewController.h"
#import "ALWebView.h"

@interface JRWebViewController () <ALWebViewDelegate>

@property (nonatomic, strong) ALWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation JRWebViewController

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
    
    if (_urlString && _urlString.length > 0) {
        [_webView loadURLString:_urlString];
    }else if (_htmlString && _htmlString.length > 0){
        [_webView loadHTMLString:_htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
    
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

//
//  WikiDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/3/12.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "WikiDetailViewController.h"
#import "JRWiki.h"
#import "ALWebView.h"
#import "ShareView.h"
#import "UIViewController+Menu.h"

@interface WikiDetailViewController ()<ALWebViewDelegate>

@property (nonatomic, strong) ALWebView *webView;

@end

@implementation WikiDetailViewController

- (void)dealloc{
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"家装百科";
//    [self configureRightBarButtonItemImage:[[ALTheme sharedTheme] imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(doShare)];
    [self configureRightBarButtonItemImage:[UIImage imageNamed:@"icon-dot"] rightBarButtonItemAction:@selector(onMenu)];
    
    self.webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (_wiki) {
        [self reloadData];
    }else{
        if (_wikiId.length > 0) {
            [self loadData];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


- (void)reloadData{
    _urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/wikis/%d%@", _wiki.wikiId,[Public shareEnv]];
    if ([_urlString containsString:@"?"]) {
        [_webView loadURLString:[NSString stringWithFormat:@"%@&fromApp=1", _urlString]];
    }else{
        [_webView loadURLString:[NSString stringWithFormat:@"%@?fromApp=1", _urlString]];
    }
}

- (void)loadData{
    NSDictionary *param = @{@"id": _wikiId};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ARTICLE_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            _wiki = [[JRWiki alloc] initWithDictionary:data];
            _wiki.wikiId = _wikiId.integerValue;
            [self reloadData];
        }else{
            [self hideHUD];
        }
    }];
}

- (void)doShare{
    [[ShareView sharedView] showWithContent:_wiki.title image:[_wiki shareImagePath] title:_wiki.title url:_urlString];
}

- (void)onMenu{
    [self showAppMenu:^{
        [[ShareView sharedView] showWithContent:_wiki.title image:[_wiki shareImagePath] title:_wiki.title url:_urlString];
    }];
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

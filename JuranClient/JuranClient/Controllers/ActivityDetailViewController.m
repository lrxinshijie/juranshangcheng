//
//  ActivityDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ALWebView.h"
#import "ShareView.h"
#import "JRActivity.h"

@interface ActivityDetailViewController ()<ALWebViewDelegate>

@property (nonatomic, strong) ALWebView *webView;

@end

@implementation ActivityDetailViewController

- (void)dealloc{
    _webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"精品活动";
    [self configureRightBarButtonItemImage:[[ALTheme sharedTheme] imageNamed:@"nav-icon-share"] rightBarButtonItemAction:@selector(doShare)];
    
    self.webView = [[ALWebView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (_activity) {
        [self reloadData];
    }else{
        if (_activityId.length > 0) {
            [self loadData];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)reloadData{
    _urlString = [NSString stringWithFormat:@"http://apph5.juran.cn/events/%d%@", _activity.activityId, [Public shareEnv]];
    if ([_urlString containsString:@"?"]) {
        [_webView loadURLString:[NSString stringWithFormat:@"%@&fromApp=1", _urlString]];
    }else{
        [_webView loadURLString:[NSString stringWithFormat:@"%@?fromApp=1", _urlString]];
    }
}

- (void)loadData{
    NSDictionary *param = @{@"id": _activityId};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_ACTIVITY_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            _activity = [[JRActivity alloc] initWithDictionary:data];
            _activity.activityId = _activityId.integerValue;
            [self reloadData];
        }else{
            [self hideHUD];
        }
    }];
}

- (void)doShare{
    [[ShareView sharedView] showWithContent:_activity.activityIntro image:[_activity shareImagePath] title:_activity.activityName url:_urlString];
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

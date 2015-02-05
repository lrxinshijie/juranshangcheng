//
//  PushMsgDetailViewController.m
//  JuranClient
//
//  Created by HuangKai on 14/12/30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "PushMsgDetailViewController.h"
#import "JRPushInfoMsg.h"
#import "SDWebImageManager.h"

@interface PushMsgDetailViewController ()<SDWebImageManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *linkButton;

@end

@implementation PushMsgDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.navigationItem.title = @"消息";
    [self setupUI];
    
    [self loadData];
}

- (void)setupUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:kContentFrameWithoutNavigationBar];
    [self.view addSubview:self.scrollView];
    
    CGRect frame = CGRectMake(10, 10, kWindowWidth - 20, 20);
    self.titleLabel = [_scrollView labelWithFrame:frame text:@"" textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    _titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:_titleLabel];
    
    frame.size = CGSizeMake(kWindowWidth - 20, 165);
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 10;
    self.imageView = [_scrollView imageViewWithFrame:frame image:nil];
    [self.scrollView addSubview:_imageView];
    
    frame.size = CGSizeMake(kWindowWidth - 20, 30);
    frame.origin.y = CGRectGetMaxY(_imageView.frame) + 10;
    self.contentLabel = [_scrollView labelWithFrame:frame text:@"" textColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14]];
    _contentLabel.numberOfLines = 0;
    [self.scrollView addSubview:_contentLabel];
    
    frame.size = CGSizeMake(kWindowWidth - 20, 30);
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 10;
    self.linkButton = [_scrollView buttonWithFrame:frame target:self action:@selector(onLink) title:@"" backgroundImage:nil];
    [self.linkButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [self.linkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.scrollView addSubview:_linkButton];
}

- (void)reloadData{
    _titleLabel.text = _pushInfo.msgTitle;
    _contentLabel.text = _pushInfo.msgContent;
    NSURL *url = [Public imageURL:_pushInfo.msgImgUrl Width:CGRectGetWidth(_imageView.frame)];
    [self setImageWithURL:url];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_pushInfo.msgLinkTitle];
    NSRange strRange = {0,[str length]};
    [str setAttributes:@{NSForegroundColorAttributeName:kBlueColor, NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSFontAttributeName: [UIFont systemFontOfSize:14]} range:strRange];//, NSWritingDirectionAttributeName: @(NSWritingDirectionLeftToRight|NSTextWritingDirectionEmbedding)
    [_linkButton setAttributedTitle:str forState:UIControlStateNormal];
    [self adjustFrame];
}

- (void)adjustFrame{
    CGRect frame = _titleLabel.frame;
    frame.size.height = [_titleLabel.text heightWithFont:_titleLabel.font constrainedToWidth:CGRectGetWidth(_titleLabel.frame)];
    _titleLabel.frame = frame;
    
    _imageView.hidden = NO;
    frame = _imageView.frame;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + 10;
    if (self.imageView.image) {
        frame.size.height = _imageView.image.size.height/_imageView.image.size.width * CGRectGetWidth(_imageView.frame);
    }
    _imageView.frame = frame;
    
    CGFloat y = CGRectGetMaxY(_imageView.frame) + 10;
    if (_pushInfo.msgImgUrl.length == 0) {
        _imageView.hidden = YES;
        y = CGRectGetMaxY(_titleLabel.frame) + 10;
    }
    
    frame = _contentLabel.frame;
    frame.origin.y = y;
    frame.size.height = [_contentLabel.text heightWithFont:_contentLabel.font constrainedToWidth:CGRectGetWidth(_titleLabel.frame)];
    _contentLabel.frame = frame;
    
    frame = _linkButton.frame;
    frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + 5;
    _linkButton.frame = frame;
    
    y = CGRectGetMaxY(_linkButton.frame);
    if (y > kWindowHeightWithoutNavigationBar) {
        _scrollView.contentSize = CGSizeMake(kWindowWidth, y);
    }
}

- (void)loadData{
    NSDictionary *param = @{@"msgId": [NSString stringWithFormat:@"%d", _pushInfo.msgId]};
    [self showHUD];
    [[ALEngine shareEngine] pathURL:JR_GET_MSG_DETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"Yes"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        [self hideHUD];
        if (!error) {
            [_pushInfo buildUpDetailWithValue:data[@"infoMsgDetailResp"]];
            [self reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLink{
    if (_pushInfo.msgLinkUrl.length > 0) {
        NSString *url = _pushInfo.msgLinkUrl;
        if (![_pushInfo.msgLinkUrl hasPrefix:@"http://"]) {
            url = [NSString stringWithFormat:@"http://%@", _pushInfo.msgLinkUrl];
        }
        NSURL *requestURL = [[NSURL alloc] initWithString:url];
        [[UIApplication sharedApplication] openURL:requestURL];
    }
}

- (void)setImageWithURL:(NSURL *)url{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image && finished) {
            self.imageView.image = image;
            [self adjustFrame];
        }
    }];
    // Remove in progress downloader from queue
//    [manager cancelAll];
//    
//    UIImage *cachedImage = nil;
//    if (url) {
//        cachedImage = [manager imageWithURL:];
//    }
//    
//    if (cachedImage) {
//        self.imageView.image = cachedImage;
//    }
//    else {
//        if (url) {
//            [manager downloadWithURL:url delegate:self];
//        }
//    }
}


- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    
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

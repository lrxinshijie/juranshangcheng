//
//  WelcomeView.m
//  JuranClient
//
//  Created by HuangKai on 15-3-10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "WelcomeView.h"
#import "SDWebImageManager.h"
#import "JRAdInfo.h"
#import "AppDelegate.h"

@interface WelcomeView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) VoidBlock block;
@property (nonatomic, strong) JRAdInfo *info;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WelcomeView

+ (void)fecthData{
#ifdef kJuranDesigner
    NSDictionary *param = @{@"adCode": @"app_designer_init_index",
                            @"areaCode": @"110000",
                            @"type": @(8)};
#else
    NSDictionary *param = @{@"adCode": @"app_consumer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(7)};
#endif
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (bannerList.count > 0) {
                NSDictionary *dic = [bannerList firstObject];
                JRAdInfo *info = [[JRAdInfo alloc] initWithDictionary:dic];
                BOOL flag = [Public saveWelcomeInfo:info];
                if (flag) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[self imageUrlWithAdInfo:info] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                    }];
                }
            }
        }
    }];
}

+ (BOOL)isShowView{
    JRAdInfo *info = [Public welcomeInfo];
    if (!info) {
        return NO;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if ([manager diskImageExistsForURL:[self imageUrlWithAdInfo:info]]) {
        return YES;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [manager downloadImageWithURL:[self imageUrlWithAdInfo:info] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        }];
    });
    return NO;
}

+ (NSURL*)imageUrlWithAdInfo:(JRAdInfo*)info{
    NSLog(@"%@", [Public imageURL:info.mediaCode Width:1080 Height:1920 Editing:YES]);
    return [Public imageURL:info.mediaCode Width:1080 Height:1920 Editing:YES];
}

- (id)init{
    self = [super init];
    if (self) {
        self.frame = kContentFrame;
        self.hidden = YES;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(kWindowWidth, CGRectGetHeight(kContentFrame)*2);
        self.scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:self.imageView];
        
        
        UIButton *btn = [self buttonWithFrame:self.bounds target:self action:@selector(onTouch:) image:nil];
        [_scrollView addSubview:btn];
        
        self.info = [Public welcomeInfo];
    }
    return self;
}

- (void)show{
    if (!_info) {
        [self unShow];
        return ;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if ([manager diskImageExistsForURL:[WelcomeView imageUrlWithAdInfo:_info]]) {
        SDImageCache *cache = [manager imageCache];
        UIImage *image = [cache imageFromDiskCacheForKey:[manager cacheKeyForURL:[WelcomeView imageUrlWithAdInfo:_info]]];
        self.imageView.image = image;
        self.hidden = NO;
        
        [self startTimeOut];
    }else{
        [self unShow];
    }
}

- (void)onTouch:(id)sender{
    [Public jumpFromLink:_info.link];
    [self unShow];
}

- (void)startTimeOut{
    [self stopTimeOut];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(unShow) userInfo:nil repeats:NO];
}

- (void)stopTimeOut{
    [_timer invalidate];
    _timer = nil;
}

- (void)unShow{
    [self stopTimeOut];
    [UIView animateWithDuration:.5 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    if (point.y > kWindowHeight/2) {
        [self unShow];
    }
}


@end

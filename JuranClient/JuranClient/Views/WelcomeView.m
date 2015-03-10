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

@interface WelcomeView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WelcomeView

+ (void)fecthData{
    NSDictionary *param = @{@"adCode": @"app_designer_index_roll",
                            @"areaCode": @"110000",
                            @"type": @(8)};
    
    [[ALEngine shareEngine] pathURL:JR_GET_BANNER_INFO parameters:param HTTPMethod:kHTTPMethodPost otherParameters:@{kNetworkParamKeyUseToken:@"NO"} delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            NSArray *bannerList = [data objectForKey:@"bannerList"];
            if (bannerList.count > 0) {
                NSDictionary *dic = [bannerList firstObject];
                BOOL flag = [Public saveWelcomeInfo:dic];
                if (flag) {
                    JRAdInfo *info = [[JRAdInfo alloc] initWithDictionary:dic];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[Public imageURL:info.mediaCode Width:kWindowWidth Height:kWindowHeight Editing:NO] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        
                    }];
                }
            }
        }
    }];
}

+ (WelcomeView *)sharedView{
    static WelcomeView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        self.frame = self.window.bounds;
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)show{
    JRAdInfo *info = [Public welcomeInfo];
    if (!info) {
        return;
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if ([manager diskImageExistsForURL:[Public imageURL:info.mediaCode Width:kWindowWidth Height:kWindowHeight Editing:NO]]) {
        [manager downloadImageWithURL:[Public imageURL:info.mediaCode Width:kWindowWidth Height:kWindowHeight Editing:NO] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (finished && !error) {
                self.imageView.image = image;
                self.alpha = 0;
                AppDelegate *app = (AppDelegate*)ApplicationDelegate;
                [app.window addSubview:self];
                [UIView animateWithDuration:.5 animations:^{
                    self.alpha = 1;
                }];
                [self startTimeOut];
            }
        }];
    }
}

- (void)startTimeOut{
    [self performSelector:@selector(unShow) withObject:nil afterDelay:3.f];
}

- (void)unShow{
    [self removeFromSuperview];
}

@end

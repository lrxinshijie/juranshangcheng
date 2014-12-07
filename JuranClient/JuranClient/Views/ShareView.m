//
//  ShareView.m
//  juranTest
//
//  Created by song.he on 14-11-22.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "ShareView.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <AGCommon/NSString+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>

#define kButtonTag   1100

@interface ShareView()<ISSViewDelegate>

@end

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (ShareView *)sharedView{
    static ShareView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init{
    self = [self initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        [self setupView];
        [self setupOneKeyList];
    }
    return self;
}

- (void)showWithContent:(NSString *)content
                  image:(NSString *)imagePath
                  title:(NSString *)title
                    url:(NSString *)url{
    
    _content = content;
    _title = title;
    _url = url;
    _imagePath = imagePath;
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
}

- (void)unShow{
    [self removeFromSuperview];
}

- (void)onShare:(id)sender{
    UIButton *btn = (UIButton*)sender;
    id<ISSContent> publishContent = [ShareSDK content:_content
                                       defaultContent:_content
                                                image:[ShareSDK imageWithUrl:_imagePath]
                                                title:_title
                                                  url:_url
                                          description:_content
                                            mediaType:SSPublishContentMediaTypeVideo];
    ShareType shareType;
    
    switch (btn.tag - kButtonTag) {
        case 0:
        {
            shareType = ShareTypeWeixiSession;
            break;
        }
        case 1:
        {
            shareType = ShareTypeWeixiTimeline;
            break;
        }
        case 2:
        {
            shareType = ShareTypeQQ;
            break;
        }
        case 3:
        {
            shareType = ShareTypeTencentWeibo;
            break;
        }
        case 4:
        {
            shareType = ShareTypeQQSpace;
            [publishContent addQQSpaceUnitWithTitle:INHERIT_VALUE
                                                url:INHERIT_VALUE
                                               site:nil
                                            fromUrl:nil
                                            comment:INHERIT_VALUE
                                            summary:INHERIT_VALUE
                                              image:INHERIT_VALUE
                                               type:INHERIT_VALUE
                                            playUrl:nil
                                               nswb:nil];
            break;
        }
        case 5:
        {
            shareType = ShareTypeSinaWeibo;
            break;
        }
        case 6:
        {
            break;
        }
        case 7:
        {
            break;
        }
        default:
            break;
    }
    /*
    
    [publishContent addInstapaperContentWithUrl:@"http://www.mob.com"
                                          title:@"Hello Instapaper"
                                    description:INHERIT_VALUE];
    [publishContent addYouDaoNoteUnitWithContent:INHERIT_VALUE
                                           title:NSLocalizedString(@"TEXT_HELLO_YOUDAO_NOTE", @"Hello 有道云笔记")
                                          author:INHERIT_VALUE
                                          source:@"http://www.mob.com"
                                     attachments:INHERIT_VALUE];*/
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:self];
    
    BOOL needAuth = NO;
    ShareType authType = shareType;
    if (shareType == ShareTypeQQ) {
        authType = ShareTypeQQSpace;
    }
    if (![ShareSDK hasAuthorizedWithType:authType])
    {
        needAuth = YES;
        [ShareSDK getUserInfoWithType:authType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   if (result)
                                   {
                                       [ShareSDK showShareViewWithType:shareType container:nil content:publishContent statusBarTips:NO authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                           
                                       }];
                                   }
                                   else
                                   {
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                           message:[NSString stringWithFormat:@"发送失败!%@", [error errorDescription]]
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"知道了"
                                                                                 otherButtonTitles:nil];
                                       [alertView show];
                                   }
                               }];
    }
    
    if (!needAuth)
    {
        //分享内容
        [ShareSDK showShareViewWithType:shareType container:nil content:publishContent statusBarTips:NO authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            
        }];

    }
    [self unShow];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    
    if ([[UIDevice currentDevice].systemVersion versionStringCompare:@"7.0"] != NSOrderedAscending)
    {
        UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
        UIButton *rightBtn = (UIButton *)viewController.navigationItem.rightBarButtonItem.customView;
        
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = viewController.title;
        label.font = [UIFont boldSystemFontOfSize:18];
        [label sizeToFit];
        
        viewController.navigationItem.titleView = label;
        
    }
    
    if ([UIDevice currentDevice].isPad)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:22];
        viewController.navigationItem.titleView = label;
        label.text = viewController.title;
        [label sizeToFit];
        
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(viewController.interfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    if ([UIDevice currentDevice].isPad)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadLandscapeNavigationBarBG.png"]];
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPadNavigationBarBG.png"]];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if ([[UIDevice currentDevice] isPhone5])
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG-568h.png"]];
            }
            else
            {
                [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneLandscapeNavigationBarBG.png"]];
            }
        }
        else
        {
            [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"iPhoneNavigationBarBG.png"]];
        }
    }
}



- (void)setupOneKeyList{
    _oneKeyShareListArray = [[NSMutableArray alloc] initWithObjects:
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             
                             
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeQQ),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeSMS),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              SHARE_TYPE_NUMBER(ShareTypeMail),
                              @"type",
                              [NSNumber numberWithBool:NO],
                              @"selected",
                              nil],
                             nil];
}

- (void)setupView{
    self.backgroundColor = [UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:.5f];
    
    CGRect frame = CGRectMake(0, 0, 300, 268);
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    frame.origin = CGPointMake((300 - 100)/2.f, 15.f);
    frame.size = CGSizeMake(100, 20);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.text = @"分享到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    [contentView addSubview:titleLabel];
    
    NSArray *imageNameArr = @[@"sns_icon_22_s.png", @"sns_icon_23_s.png", @"sns_icon_24_s.png", @"sns_icon_2_s.png", @"sns_icon_6_s.png", @"sns_icon_1_s.png"];
    NSArray *titleArr = @[@"微信好友", @"微信朋友圈", @"腾讯好友", @"腾讯微博", @"QQ空间", @"新浪微博"];
    for (NSInteger i = 0; i<6; i++) {
        frame.size = CGSizeMake(40, 40);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kButtonTag + i;
        btn.frame = frame;
        btn.center = CGPointMake(65 + 85*(i%3), 75 + (i/3)*80);
        [btn setImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        
        frame.size = CGSizeMake(70, 14);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.center = CGPointMake(65 + 85*(i%3), 108 + (i/3)*80);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithRed:85/255.f green:85/255.f blue:85/255.f alpha:1.0f];
        label.text = titleArr[i];
        [contentView addSubview:label];
    }
    
    frame.size = CGSizeMake(40, 40);
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = frame;
    cancelBtn.center = CGPointMake(150.f, 230);
    [cancelBtn setImage:[UIImage imageNamed:@"share_view_close.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(unShow) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
}

@end

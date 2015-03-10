//
//  ShareView.h
//  juranTest
//
//  Created by song.he on 14-11-22.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView
{
    NSMutableArray *_oneKeyShareListArray;
}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *weiboContent;
@property (nonatomic, copy) NSString *weiboTitle;
@property (nonatomic, assign) BOOL hasWeiboContent;

+ (ShareView *)sharedView;

- (void)showWithContent:(NSString *)content
                  image:(NSString *)imagePath
                  title:(NSString *)title
                    url:(NSString *)url;

- (void)showWithDefaultContent:(NSString *)content
                         image:(NSString *)imagePath
                         title:(NSString *)title
                           url:(NSString *)url
                  WeiboContent:(NSString*)weiboContent
                         title:(NSString*)weiboTitle;

@end

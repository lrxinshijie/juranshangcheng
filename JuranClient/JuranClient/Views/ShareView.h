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
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imagePath;

+ (ShareView *)sharedView;


- (void)showWithContent:(NSString *)content
        // defaultContent:(NSString *)defaultContent
                  image:(NSString *)imagePath
                  title:(NSString *)title
                    url:(NSString *)url;
             // mediaType:(SSPublishContentMediaType)mediaType;

@end

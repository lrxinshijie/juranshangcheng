//
//  JRWiki.h
//  JuranClient
//
//  Created by HuangKai on 15/1/17.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRWiki : NSObject

@property (nonatomic, assign) NSInteger wikiId;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger browseCount;
@property (nonatomic, assign) BOOL hasVideo;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *keyWords;
@property (nonatomic, strong) NSString *content;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;
- (NSString*)shareImagePath;

@end

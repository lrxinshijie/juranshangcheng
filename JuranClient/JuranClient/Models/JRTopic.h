//
//  JRTopic.h
//  JuranClient
//
//  Created by song.he on 14-12-4.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRTopic : NSObject

@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commentDate;
@property (nonatomic, strong) NSArray *commentImageUrlList;

//Detail
@property (nonatomic, copy) NSString *theme;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *contentDescription;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSMutableArray *commitList;
@property (nonatomic, strong) NSString *topicFlag;

- (id)initWithDictionaryForDetail:(NSDictionary *)dict;
- (void)buildUpDetialValueWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;
+ (NSMutableArray *)buildUpDetailWithValue:(id)value;
- (BOOL)isNewestTopic;

@end

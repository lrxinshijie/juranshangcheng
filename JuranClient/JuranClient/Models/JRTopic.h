//
//  JRTopic.h
//  JuranClient
//
//  Created by song.he on 14-12-4.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRTopic : NSObject

@property (nonatomic, strong) NSString *topicId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commentDate;
@property (nonatomic, strong) NSArray *commentImageUrlList;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

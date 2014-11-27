//
//  JRCase.h
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface JRCase : NSObject

@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, assign) BOOL isLike;

+ (NSMutableArray *)buildUpWithValue:(id)value;

- (NSURL *)imageURL;

@end

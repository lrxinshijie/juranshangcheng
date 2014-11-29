//
//  JRDesignerFollowDto.h
//  JuranClient
//
//  Created by song.he on 14-11-30.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDesignerFollowDto : NSObject

@property (nonatomic, strong) NSString *followId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *followUserId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *gmtCreate;
@property (nonatomic, strong) NSString *userLevel;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, assign) NSInteger priceMeasure;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, assign) NSInteger designFeeMin;
@property (nonatomic, assign) NSInteger designFeeMax;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *realNameAuth;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *browseCount;
@property (nonatomic, strong) NSString *project2DCount;
@property (nonatomic, strong) NSString *project3DCount;
@property (nonatomic, strong) NSString *followedCount;
@property (nonatomic, strong) NSString *evaluationCount;
@property (nonatomic, strong) NSString *tradeCount;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *nickName;

+ (NSMutableArray *)buildUpWithValue:(id)value;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSURL *)headImageURL;

@end

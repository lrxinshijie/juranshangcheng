//
//  JRDesigner.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDesigner : NSObject

@property (nonatomic, strong) NSString * headUrl;
@property (nonatomic, assign) NSInteger isRealNameAuth;/*实名认证	非必填	String	0:待认证;1:认证失败;2:认证成功*/
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *styleNames;
@property (nonatomic, strong) NSString *styleCodes;
@property (nonatomic, strong) NSString *selfIntroduction;
@property (nonatomic, assign) NSInteger projectCount;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger creditRateCount;
@property (nonatomic, strong) NSString *minisite;
@property (nonatomic, strong) NSArray *frontImageUrlList;
@property (nonatomic, assign) NSInteger experienceCount;
@property (nonatomic, assign) NSInteger browseCount;

//Detail
@property (nonatomic, strong) NSString *userLevel;
@property (nonatomic, strong) NSString *userLevelName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, strong) NSString *granuate;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, assign) NSInteger priceMeasure;
@property (nonatomic, assign) NSInteger designFeeMin;
@property (nonatomic, assign) NSInteger designFeeMax;
@property (nonatomic, assign) NSInteger product2DCount;
@property (nonatomic, assign) NSInteger product3DCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, strong) NSString *followId;

//MyFollow
@property (nonatomic, strong) NSString *followUserId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *gmtCreate;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *evaluationCount;
@property (nonatomic, strong) NSString *tradeCount;
@property (nonatomic, strong) NSString *realNameAuth;

//DemandDetail
@property (nonatomic, assign) NSInteger userType;


- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionaryForBidInfo:(NSDictionary *)dict;

+ (NSMutableArray *)buildUpWithValue:(id)value;

//构造设计师详情数据
- (id)buildDetailWithDictionary:(NSDictionary *)dict;

+ (NSMutableArray *)buildUpSearchDesignerWithValue:(id)value;

//构造我的关注列表数据
+ (NSMutableArray *)buildUpFollowDesignerListWithValue:(id)value;

- (NSURL *)imageURL;

- (NSString*)formatUserName;
/*
 * type  0为设计师列表   1为设计师详情  主要是分隔符不一样
 */
- (NSString*)styleNamesWithType:(NSInteger)type;

- (NSString*)experienceString;

+ (NSString*)userLevelImage:(NSString*)userLevel;

@end

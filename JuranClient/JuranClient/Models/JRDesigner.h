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
@property (nonatomic, strong) NSString *levelCode;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *styleNames;
@property (nonatomic, strong) NSString *styleCodes;
@property (nonatomic, strong) NSString *selfIntroduction;
@property (nonatomic, assign) NSInteger projectCount;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger creditRateCount;
@property (nonatomic, strong) NSString *minisite;

@property (nonatomic, strong) NSMutableArray *projectDtoList;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;

- (NSURL *)imageURL;
- (NSString*)styleNamesForDesignerList;

@end

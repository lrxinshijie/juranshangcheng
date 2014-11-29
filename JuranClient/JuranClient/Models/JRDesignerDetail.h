//
//  JRDesignerDetail.h
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDesignerDetail : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userLevel;
@property (nonatomic, strong) NSString *userLevelName;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, strong) NSString *granuate;
@property (nonatomic, assign) NSInteger experience;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, assign) NSInteger priceMeasure;
@property (nonatomic, assign) NSInteger designFeeMin;
@property (nonatomic, assign) NSInteger designFeeMax;
@property (nonatomic, strong) NSString *selfIntroduction;
@property (nonatomic, assign) NSInteger product2DCount;
@property (nonatomic, assign) NSInteger product3DCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) BOOL isFollowed;

- (id)initWithDictionary:(NSDictionary *)dict;

@end

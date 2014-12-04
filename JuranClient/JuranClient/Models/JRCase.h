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

//Detail
@property (nonatomic, copy) NSString *neighbourhoods;
@property (nonatomic, copy) NSString *roomType;
@property (nonatomic, copy) NSString *projectStyle;
@property (nonatomic, assign) NSInteger houseArea;
@property (nonatomic, assign) NSInteger projectPrice;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, strong) NSArray *detailImageList;
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *districtCode;
@property (nonatomic, copy) NSString *districtName;

//ProjectDto
@property (nonatomic, copy) NSString *designerInfoDto;
@property (nonatomic, copy) NSString *constructionTeamDto;
@property (nonatomic, copy) NSString *projectVerifyDto;
@property (nonatomic, copy) NSString *frontImgUrl;
@property (nonatomic, assign) NSInteger imgCount;
@property (nonatomic, assign) NSInteger editMemCount;
@property (nonatomic, assign) BOOL shadeFlag;
@property (nonatomic, assign) BOOL adoptFlag;
@property (nonatomic, copy) NSString *comReplyId;
@property (nonatomic, copy) NSString *communityCodeName;
@property (nonatomic, assign) BOOL isFavFlag;
@property (nonatomic, assign) BOOL isLikeFlag;
@property (nonatomic, copy) NSString *diyHelpId;
@property (nonatomic, strong) NSArray *projectPictureDtoList;
@property (nonatomic, copy) NSString *isShow;
@property (nonatomic, copy) NSString *showTime;
@property (nonatomic, assign) NSInteger projectDtoId;
@property (nonatomic, assign) NSInteger projectType;
@property (nonatomic, assign) NSInteger authorId;


+ (NSMutableArray *)buildUpWithValue:(id)value;
- (id)buildDetailWithDictionary:(NSDictionary *)dict;
- (id)buildDtoWithDictionary:(NSDictionary *)dict;

- (NSURL *)imageURL;

- (NSString *)styleString;

@end

//
//  JRCase.m
//  JuranClient
//
//  Created by 李 久龙 on 14-11-22.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRCase.h"
#import "ShareView.h"
#import "JRCaseImage.h"

@implementation JRCase

- (id)init{
    if (self = [super init]) {
        self.title = @"";
        self.areaInfo = [[JRAreaInfo alloc] init];
        self.neighbourhoods = @"";
        self.roomType = @"";
        self.stylesName = @"";
        self.houseArea = @"";
        self.projectPrice = @"";
        self.desc = @"";
        self.roomTypeImageUrl = @"";
        self.imageList = [NSMutableArray array];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.userId = [dict getIntValueForKey:@"userId" defaultValue:0];
        self.likeCount = [dict getIntValueForKey:@"likeCount" defaultValue:0];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0]; //same with member_id
        self.commentCount = [dict getIntValueForKey:@"commentCount" defaultValue:0];
        
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.desc = [dict getStringValueForKey:@"desc" defaultValue:@""];
        self.userType = [dict getStringValueForKey:@"userType" defaultValue:@""];
        self.memo = [dict getStringValueForKey:@"memo" defaultValue:@""];
        self.imageUrl = [dict getStringValueForKey:@"imageUrl" defaultValue:@""];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.projectId = [dict getStringValueForKey:@"projectId" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        
    }
    
    return self;
}

- (id)buildDetailWithDictionary:(NSDictionary *)dict{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return self;
    }
    
    self.roomNum = [dict getStringValueForKey:@"roomNum" defaultValue:@""];
    self.livingroomCount = [dict getStringValueForKey:@"livingroomCount" defaultValue:@""];
    self.bathroomCount = [dict getStringValueForKey:@"bathroomCount" defaultValue:@""];
    
    self.neighbourhoods = [dict getStringValueForKey:@"neighbourhoods" defaultValue:@""];
    self.roomType = [dict getStringValueForKey:@"roomType" defaultValue:@""];
    self.tags = [dict getStringValueForKey:@"tags" defaultValue:@""];
    self.desc = [dict getStringValueForKey:@"description" defaultValue:@""];
    self.projectStyle = [dict getStringValueForKey:@"projectStyle" defaultValue:@""];

    self.houseArea = [dict getStringValueForKey:@"houseArea" defaultValue:@""];
    self.projectPrice = [dict getStringValueForKey:@"projectPrice" defaultValue:@""];
    
    self.detailImageList = [dict objectForKey:@"detailImageList"];
    self.stylesName = [dict getStringValueForKey:@"stylesName" defaultValue:@""];
    self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:NO];
    self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
    self.isFav = [dict getBoolValueForKey:@"isFavFlag" defaultValue:NO];
    self.isLike = [dict getBoolValueForKey:@"isLikeFlag" defaultValue:NO];
    
    self.areaInfo = [[JRAreaInfo alloc] initWithDictionary:[dict objectForKey:@"areaInfo"]];
    
    //Manager
    if (self.projectStyle.length == 0) {
        self.projectStyle = [dict getStringValueForKey:@"renovationStyle" defaultValue:@""];
    }
    
    if (self.projectPrice.length == 0) {
        self.projectPrice = [dict getStringValueForKey:@"budget" defaultValue:@""];
    }
    
    self.roomTypeImageUrl = [dict getStringValueForKey:@"roomTypeImageUrl" defaultValue:@""];
    self.imageList = [JRCaseImage buildUpWithValue:[dict objectForKey:@"imageList"]];
    
    return self;
}

+ (NSMutableArray *)buildUpWithValue:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRCase *s = [[JRCase alloc] initWithDictionary:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (NSURL *)imageURL{
    return [NSURL URLWithString:self.imageUrl relativeToURL:[NSURL URLWithString:JR_IMAGE_SERVICE]];
}

- (NSString *)styleString{
    
    if (self.projectStyle.length == 0) {
        return @"";
    }
    NSArray *renovationStyle = [[DefaultData sharedData] renovationStyle];
    for (int i = 0; i<[renovationStyle count]; i++) {
        NSDictionary *row = [renovationStyle objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.projectStyle]) {
            return [row objectForKey:@"k"];
        }
    }
    
    return @"";
}

- (NSString*)styleNamesString{

    //0 为设计师 1 为设计师详情
    NSArray *arr = [self.stylesName componentsSeparatedByString:@"，"];
    NSString* styleNames = @"";
    NSString* separateStr = @"｜";
    for (NSInteger i = 0; arr.count; i++) {
        styleNames = [styleNames stringByAppendingString:arr[i]];
        if (i == arr.count - 1) {
            break;
        }
        styleNames = [styleNames stringByAppendingString:separateStr];
    }
    return styleNames;
}

- (void)like:(void (^) (BOOL result))finished{
    if (self.isLike) {
        if (finished) {
            finished(NO);
        }
        
        [Public alertOK:nil Message:@"已经点过赞"];
        return;
    }
    
    [[ALEngine shareEngine] pathURL:JR_GIVEALIKE parameters:@{@"projectId": self.projectId,@"projectType":@"1"} HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.isLike = YES;
            self.likeCount++;
        }
        if (finished) {
            finished(!error);
        }
        
    }];
}

- (void)favorite:(void (^) (BOOL result))finished{
    
    NSDictionary *param = @{@"projectId": self.projectId};
    if (!self.isFav) {
        param = @{@"projectId": self.projectId,
                  @"projectType": @"01"
                  };
    }
    [[ALEngine shareEngine] pathURL:self.isFav ? JR_CASE_UNFAVORITE : JR_CASE_FAVORITE parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.isFav = !_isFav;
        }
        if (finished) {
            finished(!error);
        }
    }];
}

- (NSString *)roomNumString{
    
    NSMutableArray *retVals = [NSMutableArray array];
    //    if (_roomNum.length > 0) {
    //        return _roomNum;
    //    }
    
    NSArray *roomNum = [[DefaultData sharedData] roomNum];
    for (int i = 0; i<[roomNum count]; i++) {
        NSDictionary *row = [roomNum objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.roomNum]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *livingroomCount = [[DefaultData sharedData] livingroomCount];
    for (int i = 0; i<[livingroomCount count]; i++) {
        NSDictionary *row = [livingroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.livingroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    NSArray *bathroomCount = [[DefaultData sharedData] bathroomCount];
    for (int i = 0; i<[bathroomCount count]; i++) {
        NSDictionary *row = [bathroomCount objectAtIndex:i];
        if ([[row objectForKey:@"v"] isEqualToString:self.bathroomCount]) {
            [retVals addObject:[row objectForKey:@"k"]];
        }
    }
    
    return [retVals componentsJoinedByString:@""];
}

- (NSString *)shareURL{
    return [NSString stringWithFormat:@"http://apph5.juran.cn/cases/%@%@",self.projectId, [Public shareEnv]];
}

- (void)doShare{
    NSString *content = self.desc;
    if (content.length == 0) {
        content = @"这里有满满的美家案例，总有一张适合你，点我收藏，做为您的灵感储备。";
    }
    [[ShareView sharedView] showWithContent:self.desc image:[Public imageURLString:self.imageUrl] title:self.title url:self.shareURL];
}

+ (NSMutableArray*)buildUpWithValueForManagement:(id)value{
    NSMutableArray *retVal = [NSMutableArray array];
    
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in value) {
            JRCase *s = [[JRCase alloc] initWithDictionaryForManagement:item];
            [retVal addObject:s];
        }
    }
    return retVal;
}

- (id)initWithDictionaryForManagement:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.frontImgUrl = [dict getStringValueForKey:@"frontImgUrl" defaultValue:@""];
        self.title = [dict getStringValueForKey:@"title" defaultValue:@""];
        self.projectId = [dict getStringValueForKey:@"projectId" defaultValue:@""];
        self.publishTime = [dict getStringValueForKey:@"publishTime" defaultValue:@""];
        self.status = [dict getStringValueForKey:@"status" defaultValue:@""];
        self.reviewType = [dict getStringValueForKey:@"reviewType" defaultValue:@""];
        self.reason = [dict getStringValueForKey:@"reason" defaultValue:@""];
    }
    
    return self;
}

- (NSString*)statusString{
    if ([_status isEqualToString:@"00"]) {
        return @"审核中";
    }else if ([_status isEqualToString:@"01"]) {
        return @"";
    }else if ([_status isEqualToString:@"02"]) {
        return @"审核未通过";
    }
    return @"";
}

- (UIColor *)statusColor{
    if ([_status isEqualToString:@"00"]) {
        return RGBColor(0, 69, 167);
    }
    return RGBColor(231, 0, 0);
}

- (CGFloat)managerCellHeight{
    CGFloat height = 75;
    if ([_status isEqualToString:@"02"] && (self.reason.length > 0 || self.reviewType.length > 0)) {
        NSString *tip = @"";
        if (self.reviewType.length > 0) {
            tip = [tip stringByAppendingFormat:@"类型：%@", self.reviewTypeString];
        }
        if (self.reason.length > 0) {
            if (tip.length > 0) {
                tip = [tip stringByAppendingString:@"\n"];
            }
            tip = [tip stringByAppendingFormat:@"原因：%@", self.reason];
        }
        height += [tip heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:280] + 10;
        height += 8;
    }
    return height;
}

- (NSString*)reviewTypeString{
    NSArray *types = [[DefaultData sharedData] objectForKey:@"reviewType"];
    for (NSDictionary *dict in types) {
        if ([dict[@"v"] integerValue] == [self.reviewType integerValue]) {
            return dict[@"k"];
        }
    }
    return @"";
}

- (void)loadDetail:(BOOLBlock)finished{
    NSDictionary *param = @{@"projectId": self.projectId};
    [[ALEngine shareEngine] pathURL:JR_MANAGER_PRODETAIL parameters:param HTTPMethod:kHTTPMethodPost otherParameters:nil delegate:self responseHandler:^(NSError *error, id data, NSDictionary *other) {
        if (!error) {
            self.userId = [data getIntValueForKey:@"userId" defaultValue:0];
            self.likeCount = [data getIntValueForKey:@"likeCount" defaultValue:0];
            self.viewCount = [data getIntValueForKey:@"viewCount" defaultValue:0]; //same with member_id
            self.commentCount = [data getIntValueForKey:@"commentCount" defaultValue:0];
            
            self.headUrl = [data getStringValueForKey:@"headUrl" defaultValue:@""];
            self.desc = [data getStringValueForKey:@"desc" defaultValue:@""];
            self.userType = [data getStringValueForKey:@"userType" defaultValue:@""];
            self.memo = [data getStringValueForKey:@"memo" defaultValue:@""];
            self.imageUrl = [data getStringValueForKey:@"imageUrl" defaultValue:@""];
            self.title = [data getStringValueForKey:@"title" defaultValue:@""];
            self.projectId = [data getStringValueForKey:@"projectId" defaultValue:@""];
            self.nickName = [data getStringValueForKey:@"nickName" defaultValue:@""];
            self.account = [data getStringValueForKey:@"account" defaultValue:@""];
            
            [self buildDetailWithDictionary:data];
        }
        if (finished) {
            finished(!error);
        }
    }];
}

@end

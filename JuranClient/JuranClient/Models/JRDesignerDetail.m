//
//  JRDesignerDetail.m
//  JuranClient
//
//  Created by song.he on 14-11-29.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "JRDesignerDetail.h"

@implementation JRDesignerDetail

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self=[self init]) {
        
        if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        
        self.userId = [dict getStringValueForKey:@"userId" defaultValue:@""];
        self.userLevel = [dict getStringValueForKey:@"userLevel" defaultValue:@""];
        self.userLevelName = [dict getStringValueForKey:@"userLevelName" defaultValue:@""];
        self.account = [dict getStringValueForKey:@"account" defaultValue:@""];
        self.nickName = [dict getStringValueForKey:@"nickName" defaultValue:@""];
        self.realName = [dict getStringValueForKey:@"realName" defaultValue:@""];
        self.headUrl = [dict getStringValueForKey:@"headUrl" defaultValue:@""];
        self.isAuth = [dict getBoolValueForKey:@"isAuth" defaultValue:FALSE];
        self.granuate = [dict getStringValueForKey:@"granuate" defaultValue:@""];
        self.experience = [dict getIntValueForKey:@"experience" defaultValue:0];
        self.style = [dict getStringValueForKey:@"style" defaultValue:@""];
        self.priceMeasure = [dict getIntValueForKey:@"priceMeasure" defaultValue:0];
        self.designFeeMin = [dict getIntValueForKey:@"designFeeMin" defaultValue:0];
        self.designFeeMax = [dict getIntValueForKey:@"designFeeMax" defaultValue:0];
        self.selfIntroduction = [dict getStringValueForKey:@"selfIntroduction" defaultValue:@""];
        self.product2DCount = [dict getIntValueForKey:@"product2DCount" defaultValue:0];
        self.product3DCount = [dict getIntValueForKey:@"product3DCount" defaultValue:0];
        self.followCount = [dict getIntValueForKey:@"followCount" defaultValue:0];
        self.viewCount = [dict getIntValueForKey:@"viewCount" defaultValue:0];
        self.isFollowed = [dict getBoolValueForKey:@"isFollowed" defaultValue:FALSE];
    }
    
    return self;
}


@end

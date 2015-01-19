//
//  JRActivity.h
//  JuranClient
//
//  Created by HuangKai on 15/1/18.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRActivity : NSObject

@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityListUrl;
@property (nonatomic, strong) NSString *activityIntro;

//Detail
@property (nonatomic, strong) NSString *activityContentUrl;
@property (nonatomic, strong) NSString *activityContent;

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;

- (void)buildUpWithValueForDetail:(id)dict;

@end

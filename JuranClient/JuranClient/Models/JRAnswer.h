//
//  JRAnswer.h
//  JuranClient
//
//  Created by song.he on 14-12-2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAnswer : NSObject

@property (nonatomic, assign) NSInteger answerId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger questionType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *commitTime;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

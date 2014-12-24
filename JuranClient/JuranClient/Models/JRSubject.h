//
//  JRSubject.h
//  JuranClient
//
//  Created by Kowloon on 14/12/2.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRSubject : NSObject

@property (nonatomic, assign) NSInteger key;
@property (nonatomic, copy) NSString *subjectUrl;
@property (nonatomic, copy) NSString *subjectName;
@property (nonatomic, copy) NSString *subjectContent;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

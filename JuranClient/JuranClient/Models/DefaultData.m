//
//  DefaultData.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DefaultData.h"

@interface DefaultData ()

@property (nonatomic, strong) NSDictionary *defaultData;

@end

@implementation DefaultData

- (instancetype)init{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DefaultData" ofType:@"plist"];
        self.defaultData = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

+ (DefaultData *)sharedData{
    static DefaultData *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSArray *)houseType{
    return [_defaultData objectForKey:@"houseType"];
}

- (NSArray *)renovationStyle{
    return [_defaultData objectForKey:@"renovationStyle"];
}

- (NSArray *)roomNum{
    return [_defaultData objectForKey:@"roomNum"];
}

- (NSArray *)livingroomCount{
    return [_defaultData objectForKey:@"livingroomCount"];
}

- (NSArray *)bathroomCount{
    return [_defaultData objectForKey:@"bathroomCount"];
}

@end

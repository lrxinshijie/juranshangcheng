//
//  DefaultData.m
//  JuranClient
//
//  Created by 李 久龙 on 14/12/14.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "DefaultData.h"

@interface DefaultData (){
    NSNumber *_imageQuality;
}

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

- (id)objectForKey:(NSString *)key{
    return [_defaultData objectForKey:key];
}

+ (DefaultData *)sharedData{
    static DefaultData *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSArray *)orderStatus{
    NSMutableArray *retVal = [NSMutableArray arrayWithArray:[self objectForKey:@"orderStatus"]];
    [retVal addObjectsFromArray:[self objectForKey:@"orderDesignerStatus"]];
    return retVal;
}

- (NSArray *)houseType{
    return [_defaultData objectForKey:@"houseType"];
}

- (NSArray *)renovationStyle{
    return [_defaultData objectForKey:@"style"];
}

- (NSArray *)roomNum{
    return [_defaultData objectForKey:@"roomType"];
}

- (NSArray *)livingroomCount{
    return [_defaultData objectForKey:@"livingroomCount"];
}

- (NSArray *)bathroomCount{
    return [_defaultData objectForKey:@"bathroomCount"];
}

- (NSArray *)professionalType{
    return [_defaultData objectForKey:@"professionalType"];
}

- (NSArray *)style{
    return [_defaultData objectForKey:@"style"];
}

- (NSArray *)special{
    return [_defaultData objectForKey:@"special"];
}

- (NSArray*)sex{
    return [_defaultData objectForKey:@"sex"];
}

- (NSNumber *)imageQuality{
    if (!_imageQuality) {
        _imageQuality = [Public imageQuality];
    }
    
    return _imageQuality;
}

- (void)setImageQuality:(NSNumber *)imageQuality{
    _imageQuality = imageQuality;
    [Public setImageQuality:imageQuality];
}

@end

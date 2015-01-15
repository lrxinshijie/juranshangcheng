//
//  JRCaseImage.h
//  JuranClient
//
//  Created by Kowloon on 15/1/10.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRCaseImage : NSObject

@property (nonatomic, copy) NSString *imageId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL frontFlag;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *picType;
@property (nonatomic, copy) NSString *picRoom;

- (NSDictionary *)dictionaryValue;

+ (NSMutableArray *)buildUpWithValue:(id)value;

@end

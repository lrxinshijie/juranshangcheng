//
//  SecondLevelItem.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/20.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    Location_None = 0,
    Location_Left,
    Location_Middle,
    Location_Right
    
}Location;

#define NormalColor [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define SelectColor [UIColor colorWithRed:11.0/255.0 green:81.0/255.0 blue:168.0/255.0 alpha:1.0]

@interface SecondLevelItem : NSObject

@property (assign, nonatomic) BOOL isSelect;
@property (assign, nonatomic) Location selectLocation;

@property (strong, nonatomic) NSString * lImage;
@property (strong, nonatomic) NSString * lText;
@property (strong, nonatomic) NSString * lID;
@property (strong, nonatomic) UIColor * lColor;

@property (strong, nonatomic) NSString * mImage;
@property (strong, nonatomic) NSString * mText;
@property (strong, nonatomic) NSString * mID;
@property (strong, nonatomic) UIColor * mColor;

@property (strong, nonatomic) NSString * rImage;
@property (strong, nonatomic) NSString * rText;
@property (strong, nonatomic) NSString * rID;
@property (strong, nonatomic) UIColor * rColor;



- (SecondLevelItem *)initSecondLevelItem;

@end

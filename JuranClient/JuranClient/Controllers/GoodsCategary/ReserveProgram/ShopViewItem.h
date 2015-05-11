//
//  ShopViewItem.h
//  JuranClient
//
//  Created by 陈晓宁 on 15/4/24.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopViewItem : NSObject


@property (strong, nonatomic)NSString * lImageURL;
@property (strong, nonatomic)NSString * lText;
@property (strong, nonatomic)NSString * lcode;
@property (strong, nonatomic)NSString * lid;


@property (strong, nonatomic)NSString * rImageURL;
@property (strong, nonatomic)NSString * rText;
@property (strong, nonatomic)NSString * rcode;
@property (strong, nonatomic)NSString * rid;

@end

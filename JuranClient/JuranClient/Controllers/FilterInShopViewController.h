//
//  FilterInShopViewController.h
//  JuranClient
//
//  Created by 彭川 on 15/4/15.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
typedef void (^FilterSelected)(long catId);
@interface FilterInShopViewController : ALViewController
@property (nonatomic, copy) FilterSelected block;
- (void)setFinishBlock:(FilterSelected)finished;

@property (nonatomic, assign) long shopId;
@end

@interface FilterInShop : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long parentId;
@property (nonatomic, assign) int depth;
@property (nonatomic, assign) long Id;

@property (nonatomic, strong) NSMutableArray *childList;

- (id)initWithDictionary:(NSDictionary*)dict;
+ (NSMutableArray*)buildUpWithValueForList:(id)value;
@end

//
//  JRShopOrProduceComment.h
//  JuranClient
//
//  Created by 123 on 15/11/13.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRReplyModel.h"

@interface JRShopOrProduceComment : NSObject

//@property (nonatomic, copy) NSString *relId; //商品店铺id
//@property (nonatomic, copy) NSString *rank; //评级
@property (nonatomic, assign) NSInteger id;//点评id
@property (nonatomic, copy) NSString *userNickname;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userImg;
@property (nonatomic, assign) NSInteger rank;

@property(nonatomic,copy) NSString *content;
@property(nonatomic,strong) NSArray *imgList;
@property(nonatomic,copy) NSString *gmtCreate;

@property(nonatomic,assign) NSInteger vote;
@property(nonatomic,strong) NSMutableArray *arrReplyList;
//Reply
//@property (nonatomic, copy) NSString *replyContent;
//@property (nonatomic, copy) NSString *replyTime;
//@property (nonatomic, assign) NSInteger replyId;
@property (nonatomic, assign) BOOL isfolder;
@property(nonatomic,assign) BOOL isDelete;

@property(nonatomic,assign) float height;
@property (nonatomic, copy) NSString *relName;//商品或者店铺名字

- (id)initWithDictionary:(NSDictionary *)dict;
+ (NSMutableArray *)buildUpWithValue:(id)value;


@end

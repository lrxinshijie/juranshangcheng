//
//  CommentListViewController.h
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import "ALViewController.h"
#import "CommentListCell.h"
#import "JRShopOrProduceComment.h"
#import "JRReplyModel.h"

typedef enum {
    ENUM_ShopType=2,
    ENUM_ProductType=1//商品
} ENUM_Type;




@interface CommentListViewController : ALViewController<UITableViewDataSource,UITableViewDelegate,CommentListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,assign) NSInteger InActionType; //操作类型

@property (nonatomic, assign) NSInteger relId;

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *shopName;


- (void)addCommentClick;
-(void)refreshPage;


@end

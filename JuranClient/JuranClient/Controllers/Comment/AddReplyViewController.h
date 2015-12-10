//
//  AddReplyViewController.h
//  JuranClient
//
//  Created by 123 on 15/11/19.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALViewController.h"
#import "JRReplyModel.h"
#import "JRShopOrProduceComment.h"
#import "CommentStarView.h"

@interface AddReplyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *txtReply;
- (IBAction)btnSendClick:(id)sender;
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,strong) JRReplyModel *model;
@property(nonatomic,strong) JRShopOrProduceComment *commentModel;


@end

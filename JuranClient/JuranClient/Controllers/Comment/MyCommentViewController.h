//
//  MyCommentViewController.h
//  JuranClient
//
//  Created by 123 on 15/11/9.
//  Copyright (c) 2015年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALViewController.h"
#import "JRSegmentControl.h"
#import "CommentListViewController.h"

@interface MyCommentViewController : ALViewController
@property (strong, nonatomic) IBOutlet UIView *footerView;
- (IBAction)btnDeleteClick:(id)sender;
@property (weak, nonatomic) IBOutlet JRSegmentControl *segment;
@property (nonatomic,assign) NSInteger InActionType; //操作类型
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

//@property (nonatomic, copy) NSString *goodsName;
//@property (nonatomic, copy) NSString *shopName;

@end

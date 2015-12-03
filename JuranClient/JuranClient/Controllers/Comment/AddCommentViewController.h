//
//  AddCommentViewController.h
//  JuranClient
//
//  Created by 123 on 15/11/5.
//  Copyright (c) 2015年 Juran. All rights reserved.
//


#import "ALViewController.h"
#import "ZoomInImageView.h"
#import "CommentStarView.h"

@interface AddCommentViewController : ALViewController
@property (weak, nonatomic) IBOutlet CommentStarView *commentStarView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *labRemain;

@property(nonatomic,assign) NSInteger relId;
;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labStarCount;
@property (weak, nonatomic) IBOutlet UILabel *labRemainCount;
@property (nonatomic,assign) NSInteger InActionType; //操作类型


@end

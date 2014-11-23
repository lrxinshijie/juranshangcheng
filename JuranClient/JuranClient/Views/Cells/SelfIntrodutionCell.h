//
//  SelfIntrodutionCell.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelfIntroductionCellDelegate;

@interface SelfIntrodutionCell : UITableViewCell

@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL isClose;
@property (nonatomic, weak) id<SelfIntroductionCellDelegate> delegate;

@end

@protocol SelfIntroductionCellDelegate <NSObject>

- (void)heightChanged:(SelfIntrodutionCell*) cell;

@end
//
//  AskDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-6.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRQuestion;
@class AskDetailViewController;

@protocol AskDetailViewControllerDelegate <NSObject>

- (void)answeredWithAskDetailViewController:(AskDetailViewController*)vc;

@end

@interface AskDetailViewController : ALViewController

@property (nonatomic, weak) id<AskDetailViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL isMyQuestion;
@property (nonatomic, strong) JRQuestion *question;

@end

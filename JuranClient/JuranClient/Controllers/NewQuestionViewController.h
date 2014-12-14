//
//  NewQuestionViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-10.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class NewQuestionViewController;

@protocol NewQuestionViewControllerDelegate <NSObject>

- (void)newQuestionViewController:(NewQuestionViewController*) vc ;

@end

@interface NewQuestionViewController : ALViewController

@property (nonatomic, weak) id<NewQuestionViewControllerDelegate> delegate;

@end

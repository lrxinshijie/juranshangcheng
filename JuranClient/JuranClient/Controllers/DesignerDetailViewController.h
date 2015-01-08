//
//  DesignerDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;
@class DesignerDetailViewController;

@protocol DesignerDetailViewControllerDelegate <NSObject>

- (void)changeFollowStatus:(DesignerDetailViewController*)vc withDesigner:(JRDesigner*)designer status:(BOOL) isFollow;

@end

@interface DesignerDetailViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;
@property (nonatomic, strong) NSMutableArray *caseDatas;
@property (nonatomic, strong) NSMutableArray *topicDatas;
@property (nonatomic, weak) id<DesignerDetailViewControllerDelegate> delegate;
#ifdef kJuranDesigner
@property (nonatomic, assign) BOOL isHomePage;
#endif

@end

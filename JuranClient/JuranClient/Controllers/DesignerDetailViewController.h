//
//  DesignerDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;

@interface DesignerDetailViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;
@property (nonatomic, strong) NSMutableArray *caseDatas;
@property (nonatomic, strong) NSMutableArray *topicDatas;
@end

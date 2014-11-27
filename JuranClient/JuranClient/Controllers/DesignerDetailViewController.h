//
//  DesignerDetailViewController.h
//  JuranClient
//
//  Created by song.he on 14-11-23.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;
@class JRDesignerDetail;

@interface DesignerDetailViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;
@property (nonatomic, strong) JRDesignerDetail *designerDetail;

@end

//
//  PrivateLetterViewController.h
//  JuranClient
//
//  Created by Kowloon on 14/12/17.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@class JRDesigner;
@interface PrivateLetterViewController : ALViewController

@property (nonatomic, strong) JRDesigner *designer;
@property (nonatomic, assign) NSInteger receiverId;


@end

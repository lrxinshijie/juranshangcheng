//
//  SearchViewController.h
//  JuranClient
//
//  Created by song.he on 14-12-9.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import "ALViewController.h"

@interface SearchViewController : ALViewController

@property (nonatomic, assign) SearchType type;
@property (nonatomic, assign) BOOL foucs;
@property (nonatomic, strong) UITableView *tableView;
@end

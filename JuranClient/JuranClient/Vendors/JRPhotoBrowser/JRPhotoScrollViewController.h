//
//  JRPhotoScrollViewController.h
//  MyTest
//
//  Created by song.he on 14-11-26.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "KTPhotoScrollViewController.h"
#import "JRCase.h"
#import "KTPhotoView+SDWebImage.h"

@interface JRPhotoScrollViewController : KTPhotoScrollViewController

@property (nonatomic, strong) JRCase *jrCase;

- (id)initWithJRCase:(JRCase*)c andStartWithPhotoAtIndex:(NSUInteger)index;

@end

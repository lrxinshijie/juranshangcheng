//
//  JRPhotoScrollViewController.h
//  MyTest
//
//  Created by song.he on 14-11-26.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import "JRCase.h"
#import "MWPhotoBrowser.h"

@interface JRPhotoScrollViewController : MWPhotoBrowser

@property (nonatomic, strong) JRCase *jrCase;

- (id)initWithJRCase:(JRCase*)c andStartWithPhotoAtIndex:(NSUInteger)index;

@end

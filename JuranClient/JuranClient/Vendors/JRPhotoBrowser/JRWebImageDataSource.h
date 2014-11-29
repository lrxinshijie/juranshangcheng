//
//  JRWebImageDataSource.h
//  MyTest
//
//  Created by song.he on 14-11-27.
//  Copyright (c) 2014年 song.he. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"

@interface JRWebImageDataSource : NSObject<KTPhotoBrowserDataSource>
{
    NSArray *images_;
}

@end

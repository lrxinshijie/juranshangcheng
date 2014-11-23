//
//  NSMutableArray+ASCategory.h
//  Supplement
//
//  Created by Kowloon on 12-4-28.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ASCategory)

- (void)sortUsingSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;    // sorts the array itself

- (void)sortUsingSortDescriptorWithKeys:(NSArray *)keys;

@end

//
//  CaseCollectionCell.h
//  JuranClient
//
//  Created by Kowloon on 14/11/25.
//  Copyright (c) 2014年 Juran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCase;
@interface CaseCollectionCell : UICollectionViewCell

- (void)fillCellWithCase:(JRCase *)data;

@end

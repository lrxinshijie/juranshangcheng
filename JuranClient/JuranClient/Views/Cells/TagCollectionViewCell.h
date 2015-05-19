//
//  TagCollectionViewCell.h
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *label;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isEnable;

@end

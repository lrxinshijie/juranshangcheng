//
//  TagCollectionViewCell.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)drawRect:(CGRect)rect
{
	// inset by half line width to avoid cropping where line touches frame edges
	CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:3];
	
	// white background
	[[UIColor whiteColor] setFill];
	[path fill];

	// red outline
    [_isSelect ? kBlueColor : [UIColor blackColor] setStroke];
	[path stroke];
    
    _label.textColor = _isSelect ? kBlueColor : [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected{
    _isSelect = selected;
    
    [self setNeedsDisplay];
//    _label.textColor = kBlueColor;
//    _label.textColor = _isSelect ? kBlueColor : [UIColor blackColor];
}

@end

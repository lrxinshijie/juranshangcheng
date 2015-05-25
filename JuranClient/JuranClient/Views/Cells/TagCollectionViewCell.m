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
    
    UIColor *color = [UIColor darkGrayColor];
    if (_isEnable) {
        color = _isSelect ? kBlueColor : [UIColor blackColor];
    }else {
        color = RGBColor(207, 207, 207);
    }
    
    [color setStroke];
	[path stroke];
    
    _label.textColor = color;
}

- (void)setSelected:(BOOL)selected{
    _isSelect = selected;
    
    [self setNeedsDisplay];
//    _label.textColor = kBlueColor;
//    _label.textColor = _isSelect ? kBlueColor : [UIColor blackColor];
}

@end

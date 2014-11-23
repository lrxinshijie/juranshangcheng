//
//  ASMaskdView.m
//  Network
//
//  Created by Kowloon on 12-10-18.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ASMaskdView.h"

@interface ASMaskdView ()

@property (strong, nonatomic) CAShapeLayer *borderBottomLayer;

- (void)configureDefaultValue;
- (void)drawSelectedMaskAtPosition:(CGFloat)position;

@end

@implementation ASMaskdView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self configureDefaultValue];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    ((CAShapeLayer *)self.layer).fillColor = _fillColor.CGColor;
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = .3;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    
    [self drawSelectedMaskAtPosition:_selectedMaskPosition];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    _borderBottomLayer.strokeColor = _strokeColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    _borderBottomLayer.lineWidth = _lineWidth;
}

- (void)setSelectedMaskPosition:(CGFloat)selectedMaskPosition
{
    _selectedMaskPosition = selectedMaskPosition;
    [self setNeedsLayout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Private

- (void)configureDefaultValue
{
    self.backgroundColor = [UIColor clearColor];
    
    self.fillColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1];
    self.strokeColor = [UIColor whiteColor];
    self.lineWidth = 1;
    self.selectedMaskPosition = self.frame.size.width * .5;
    self.arrowSize = 6;
}

- (void)drawSelectedMaskAtPosition:(CGFloat)position
{
    
    CGRect bounds = self.bounds;
    CGFloat left = CGRectGetMinX(bounds);
    CGFloat right = CGRectGetMaxX(bounds);
    CGFloat top = CGRectGetMaxY(bounds);
    CGFloat bottom = CGRectGetMinY(bounds);
    
    //
    // Mask
    //
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:bounds.origin];
    [path addLineToPoint:CGPointMake(bottom, top)];
    [path addLineToPoint:CGPointMake(right, top)];
    [path addLineToPoint:CGPointMake(right, bottom)];
    if (position >= 0)
    {
        [path addLineToPoint:CGPointMake(position + self.arrowSize, bottom)];
        [path addLineToPoint:CGPointMake(position, self.arrowSize)];
        [path addLineToPoint:CGPointMake(position - self.arrowSize, bottom)];
    }
    [path addLineToPoint:CGPointMake(left, bottom)];
    [path addLineToPoint:bounds.origin];
    
    ((CAShapeLayer *)self.layer).path = path.CGPath;
    
    //
    // Bottom line
    //
    if (!_borderBottomLayer)
    {
        _borderBottomLayer = [CAShapeLayer layer];
        _borderBottomLayer.strokeColor = _strokeColor.CGColor;
        _borderBottomLayer.lineWidth = _lineWidth;
        _borderBottomLayer.fillColor = nil;
//        _borderBottomLayer.shadowColor = [UIColor blackColor].CGColor;
//        _borderBottomLayer.shadowRadius = 2;
//        _borderBottomLayer.shadowOpacity = .6;
//        _borderBottomLayer.shadowOffset = CGSizeMake(0, 1);
        [self.layer addSublayer:_borderBottomLayer];
    }
    _borderBottomLayer.frame = self.bounds;
    
    UIBezierPath *borderBottomPath = [UIBezierPath bezierPath];
    CGFloat lineY = bottom - _borderBottomLayer.lineWidth / 2;
    //CGFloat lineY = bottom;
    [borderBottomPath moveToPoint:CGPointMake(left, lineY)];
    if (position >= 0)
    {
        [borderBottomPath addLineToPoint:CGPointMake(position - self.arrowSize + _borderBottomLayer.lineWidth, lineY)];
        [borderBottomPath addLineToPoint:CGPointMake(position, self.arrowSize + _borderBottomLayer.lineWidth / 2)];
        [borderBottomPath addLineToPoint:CGPointMake(position + self.arrowSize, lineY)];
    }
    [borderBottomPath addLineToPoint:CGPointMake(right, lineY)];
    _borderBottomLayer.path = borderBottomPath.CGPath;
    
    //
    // Shadow mask
    //
    top += bottom - _arrowSize - _lineWidth * 2;
    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
    [shadowPath moveToPoint:CGPointMake(left, top)];
    [shadowPath addLineToPoint:CGPointMake(right, top)];
    [shadowPath addLineToPoint:CGPointMake(right, bottom)];
    if (position >= 0)
    {
        [shadowPath addLineToPoint:CGPointMake(position + self.arrowSize, bottom)];
        [shadowPath addLineToPoint:CGPointMake(position, self.arrowSize)];
        [shadowPath addLineToPoint:CGPointMake(position - self.arrowSize, bottom)];
    }
    [shadowPath addLineToPoint:CGPointMake(left, bottom)];
    [shadowPath addLineToPoint:bounds.origin];
    
    self.layer.shadowPath = shadowPath.CGPath;
    
//    UIBezierPath *shadowPath = [UIBezierPath bezierPath];
////    CGMutablePathRef shadowPath = CGPathCreateMutable();
////    CGPoint points[5];
////    points[0] = CGPointMake(left, bottom + self.layer.shadowOffset.height);
////    points[1] = CGPointMake(position - self.arrowSize, bottom);
////    points[2] = CGPointMake(position, bottom - self.arrowSize);
////    points[3] = CGPointMake(position + self.arrowSize, bottom);
////    points[4] = CGPointMake(left, bottom + self.layer.shadowOffset.height);
////    CGPathAddLines(shadowPath, NULL, points, 5);
//    [shadowPath moveToPoint:CGPointMake(left, bottom + self.layer.shadowOffset.height)];
//    if (position >= 0)
//    {
//        [shadowPath addLineToPoint:CGPointMake(position - self.arrowSize, bottom)];
//        [shadowPath addLineToPoint:CGPointMake(position, bottom - self.arrowSize)];
//        [shadowPath addLineToPoint:CGPointMake(position + self.arrowSize, bottom)];
//    }
//    [shadowPath addLineToPoint:CGPointMake(right, bottom + self.layer.shadowOffset.height)];
//    self.layer.shadowPath = shadowPath.CGPath;
}

@end

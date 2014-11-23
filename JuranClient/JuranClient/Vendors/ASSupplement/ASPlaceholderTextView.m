//
//  ASPlaceholderTextView.m
//  ASSupplement
//
//  Created by Kowloon on 12-3-6.
//  Copyright (c) 2012年 Goome. All rights reserved.
//

#import "ASPlaceholderTextView.h"

@interface ASPlaceholderTextView ()

- (void)_initialize;
- (void)_textChanged:(NSNotification *)notification;

@end


@implementation ASPlaceholderTextView

#pragma mark - Accessors

- (void)setText:(NSString *)string {
	[super setText:string];
	[self setNeedsDisplay];
}


- (void)insertText:(NSString *)string {
	[super insertText:string];
	[self setNeedsDisplay];
}


- (void)setAttributedText:(NSAttributedString *)attributedText {
	[super setAttributedText:attributedText];
	[self setNeedsDisplay];
}


- (void)setPlaceholder:(NSString *)string {
	if ([string isEqual:_placeholder]) {
		return;
	}
	
	_placeholder = string;
	[self setNeedsDisplay];
}


- (void)setContentInset:(UIEdgeInsets)contentInset {
	[super setContentInset:contentInset];
	[self setNeedsDisplay];
}


- (void)setFont:(UIFont *)font {
	[super setFont:font];
	[self setNeedsDisplay];
}


- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	[super setTextAlignment:textAlignment];
	[self setNeedsDisplay];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _initialize];
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    
	if (self.text.length == 0 && self.placeholder) {
		// Inset the rect
		rect = UIEdgeInsetsInsetRect(rect, self.contentInset);
        
		// TODO: This is hacky. Not sure why 8 is the magic number
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
        
		// Draw the text
		[_placeholderColor set];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
#else
        //iOS7
//		[_placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
        [_placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByWordWrapping alignment:self.textAlignment];
#endif
	}
}


#pragma mark - Private

- (void)_initialize {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
	
	self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
}


- (void)_textChanged:(NSNotification *)notification {
	[self setNeedsDisplay];
}

@end

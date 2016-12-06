//
//  JBorderedView.m
//  Turfmapp
//
//  Created by Костя Колесник on 25.11.14.
//  Copyright (c) 2014 Turfmapp Team. All rights reserved.
//

#import "JBorderedView.h"

@implementation JBorderedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGFloat width = self.borderWidth;
    if (width>0 && width<1) width = 1;
    CGContextSetLineWidth(context, width);
    
    
    if (self.leftBorder) {
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, 0.0f, self.frame.size.height);
    }
    if (self.rightBorder) {
        CGContextMoveToPoint(context, self.frame.size.width, 0.0f);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    }
    if (self.topBorder) {
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, self.frame.size.width, 0.0f);
    }
    if (self.bottomBorder) {
        CGContextMoveToPoint(context, 0.0f, self.frame.size.height);
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
    }
    CGContextStrokePath(context);
}

-(void)setBottomBorder:(BOOL)bottomBorder
{
    _bottomBorder = bottomBorder;
    [self setNeedsDisplay];
}

-(void)setTopBorder:(BOOL)topBorder
{
    _topBorder = topBorder;
    [self setNeedsDisplay];
}

-(void)setLeftBorder:(BOOL)leftBorder
{
    _leftBorder = leftBorder;
    [self setNeedsDisplay];
}

-(void)setRightBorder:(BOOL)rightBorder
{
    _rightBorder = rightBorder;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

@end

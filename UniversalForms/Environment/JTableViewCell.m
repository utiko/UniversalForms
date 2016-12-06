//
//  JTableViewCell.m
//  iPadPopovers
//
//  Created by Kostia Kolesnyk on 11/24/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JTableViewCell.h"
#import "uTikoGraphic.h"

@implementation JTableViewCell {
    BOOL isFirstCell;
    BOOL isLastCell;
    BOOL iPadMode;
    CGRect iPadLastMaskSize;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!_selectionColor) {
        self.selectionColor = [UIColor colorWithHexString:@"efefef"];
    }
}

-(void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = selectionColor;
    [self setSelectedBackgroundView:bgColorView];
}

-(void)setFrame:(CGRect)frame
{
    if (self.maxCellWidth == 0) self.maxCellWidth = 600;
    
    iPadMode = self.superview.frame.size.width > self.maxCellWidth;
    
    if (iPadMode) {
        float delta = (self.superview.frame.size.width - self.maxCellWidth) / 2;
        if (frame.origin.x < delta) frame.origin.x = frame.origin.x + delta;
        frame.size.width = self.maxCellWidth;
    }
    [super setFrame:frame];
    //[self.contentView setFrame:self.bounds];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (iPadMode) {
        [self refreshiPadCellBorders];
    }
}

-(void)prepareForDisplayInTableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath
{
    isFirstCell = indexPath.row == 0;
    isLastCell = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] -1;
    
    if (iPadMode) {
        [self refreshiPadCellBorders];
    }
}

- (void)refreshiPadCellBorders
{
    if (CGRectEqualToRect(iPadLastMaskSize, self.frame)) return;
    
    iPadLastMaskSize = self.frame;
    
    CGFloat cornerRadius = 6.f;
    
    UIBezierPath *maskPath;
    if (isFirstCell && isLastCell) {
        maskPath = [UIBezierPath
                    bezierPathWithRoundedRect:self.bounds
                    cornerRadius:cornerRadius
                    ];
    } else if (isFirstCell) {
        maskPath = [UIBezierPath
                    bezierPathWithRoundedRect:self.bounds
                    byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                    cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
                    ];
    } else if (isLastCell) {
        maskPath = [UIBezierPath
                    bezierPathWithRoundedRect:self.bounds
                    byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                    cornerRadii:CGSizeMake(cornerRadius, cornerRadius)
                    ];
    }
    if (maskPath) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    } else {
        self.layer.mask = nil;
    }
}

@end

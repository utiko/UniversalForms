//
//  JFormElementTextViewCell.m
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormElementTextViewCell.h"

@implementation JFormElementTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)heightForCellWithText:(NSString *)text width:(CGFloat)width
{
    if (width > 500) width = 500;
    CGSize maxSize = CGSizeMake(width - 30, MAXFLOAT);
    CGRect rect = [text boundingRectWithSize:maxSize options:0 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height;
    if (height < 30) height = 30;
    return height + 34 + 8;
}

@end

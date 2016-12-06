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
    CGSize maxSize = CGSizeMake(width - 30, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:14]} context:nil];
    CGFloat height = rect.size.height;
    if (height < 22) height = 22;
    NSLog(@"%@ %@", @(height), text);
    return height + 58;
}

@end

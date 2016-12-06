//
//  JFormElementTextViewCell.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormElementCell.h"

@interface JFormElementTextViewCell : JFormElementCell

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (CGFloat)heightForCellWithText:(NSString *)text width:(CGFloat)width;

@end

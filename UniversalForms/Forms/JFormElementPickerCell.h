//
//  JFormElementPickerCell.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/5/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormElementCell.h"

@interface JFormElementPickerCell : JFormElementCell

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectIcon;

@end

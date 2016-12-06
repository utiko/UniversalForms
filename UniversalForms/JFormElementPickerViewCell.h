//
//  JFormElementPickerViewCell.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/6/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JTableViewCell.h"
#import "JBorderedView.h"

@interface JFormElementPickerViewCell : JTableViewCell

@property (weak, nonatomic) IBOutlet JBorderedView *borderView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

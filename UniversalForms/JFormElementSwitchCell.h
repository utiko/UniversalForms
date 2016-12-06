//
//  JFormElementSwitchCell.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/5/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormElementCell.h"

@interface JFormElementSwitchCell : JFormElementCell


@property (weak, nonatomic) IBOutlet UILabel * placeholderLabel;
@property (weak, nonatomic) IBOutlet UISwitch * elementSwitch;

@end

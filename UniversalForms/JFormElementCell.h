//
//  JFormElementCell.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/5/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JTableViewCell.h"
#import "JBorderedView.h"

@interface JFormElementCell : JTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet JBorderedView *borderView;

@end

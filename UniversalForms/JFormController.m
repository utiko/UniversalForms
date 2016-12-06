//
//  JFormController.m
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormController.h"

@interface JFormController ()

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, weak) JFormElement * selectedFormElement;

@end


@implementation JFormController

-(instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        
        UINib * textViewCellNib = [UINib nibWithNibName:@"JFormElementTextViewCell" bundle:nil];
        [self.tableView registerNib:textViewCellNib forCellReuseIdentifier:@"JFormElementTextViewCell"];

        UINib * pickerCellNib = [UINib nibWithNibName:@"JFormElementPickerCell" bundle:nil];
        [self.tableView registerNib:pickerCellNib forCellReuseIdentifier:@"JFormElementPickerCell"];

        UINib * switchCellNib = [UINib nibWithNibName:@"JFormElementSwitchCell" bundle:nil];
        [self.tableView registerNib:switchCellNib forCellReuseIdentifier:@"JFormElementSwitchCell"];

        UINib * textFieldCellNib = [UINib nibWithNibName:@"JFormElementTextFieldCell" bundle:nil];
        [self.tableView registerNib:textFieldCellNib forCellReuseIdentifier:@"JFormElementTextFieldCell"];

        UINib * splitterCellNib = [UINib nibWithNibName:@"JFormElementSplitterCell" bundle:nil];
        [self.tableView registerNib:splitterCellNib forCellReuseIdentifier:@"JFormElementSplitterCell"];
        
        UINib * pickerViewCellNib = [UINib nibWithNibName:@"JFormElementPickerViewCell" bundle:nil];
        [self.tableView registerNib:pickerViewCellNib forCellReuseIdentifier:@"JFormElementPickerViewCell"];
        
        UINib * datePickerViewCellNib = [UINib nibWithNibName:@"JFormElementDatePickerViewCell" bundle:nil];
        [self.tableView registerNib:datePickerViewCellNib forCellReuseIdentifier:@"JFormElementDatePickerViewCell"];
    }
    return self;
}

-(void)setFormElements:(NSArray *)formElements
{
    _formElements = formElements;
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.formElements.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    if (formElement.elementType == JFormElementTypePicker) {
        return 2;
    }
    if (formElement.elementType == JFormElementTypeDatePicker) {
        return 2;
    }
    if (formElement.elementType == JFormElementTypeCustomPicker) {
        return [self.delegate formController:self numberOfPickerItemsForFormElement:formElement] + 1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFormElement * formElement = [self.formElements objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        /// Dynamic size for TextView element
        if (formElement.elementType == JFormElementTypeTextView) {
            NSString * text = [self.delegate formController:self valueForElement:formElement];
            return [JFormElementTextViewCell heightForCellWithText:text width:tableView.frame.size.width];
        }
        
        /// Presetted value in JFormElement
        if (formElement.height > 0) return formElement.height;
        
        /// Delegate value (skip if <0)
        if ([self.delegate respondsToSelector:@selector(formController:heightForFormElement:)]) {
            CGFloat height = [self.delegate formController:self heightForFormElement:formElement];
            if (height >= 0) return height;
        }
        
        /// Defaults
        if (formElement.elementType == JFormElementTypeTextField) {
            return 70;
        }
        if (formElement.elementType == JFormElementTypeSplitter) {
            return 30;
        }
        
        if ([self.delegate respondsToSelector:@selector(formController:descriptionForPickerElement:)]) {
            // For picker with description
            NSString * description = [self.delegate formController:self descriptionForPickerElement:formElement];
            if (description) return 100;
        }
        return 60;
        
    } else {
        
        if (formElement.elementType == JFormElementTypePicker || formElement.elementType == JFormElementTypeDatePicker) {
            if (formElement == self.selectedFormElement) {
                return 218;
            } else {
                return 0;
            }
        }
        
        if (formElement.elementType == JFormElementTypeCustomPicker) {
            if (formElement == self.selectedFormElement) {
                NSInteger index = indexPath.row - 1;
                return [self.delegate formController:self heightForCustomPickerItemWithIndex:index forFormElement:formElement];
            } else {
                return 1;
            }
        }
    }
    
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFormElement * formElement = [self.formElements objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        /// TextView cell
        if (formElement.elementType == JFormElementTypeTextView) {
            NSString * text = [self.delegate formController:self valueForElement:formElement];
            
            JFormElementTextViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementTextViewCell"];
            cell.textView.text = text;
            return cell;
        }
        
        /// Custom cells
        if ([self.delegate respondsToSelector:@selector(formController:customCellForFormElement:)]) {
            UITableViewCell * cell = [self.delegate formController:self customCellForFormElement:formElement];
            if ([cell isKindOfClass:[UITableViewCell class]]) return cell;
        }
        
        /// Default cells
        if (formElement.elementType == JFormElementTypePicker || formElement.elementType == JFormElementTypeCustomPicker) {
            JFormElementPickerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementPickerCell"];
            cell.titleLabel.text = formElement.elementTitle;
            NSString * value = [self.delegate formController:self valueForElement:formElement];
            if ([value isKindOfClass:[NSString class]]) {
                cell.placeholderLabel.hidden = YES;
                cell.valueLabel.hidden = NO;
                cell.valueLabel.text = value;
            } else {
                cell.placeholderLabel.hidden = NO;
                cell.valueLabel.hidden = YES;
                cell.placeholderLabel.text = formElement.elementPlaceholder;
            }
            if ([self.delegate respondsToSelector:@selector(formController:descriptionForPickerElement:)]) {
                NSString * description = [self.delegate formController:self descriptionForPickerElement:formElement];
                if (description) cell.descriptionLabel.text = description;
                else description = @"";
            }
            return cell;
        }
        
        if (formElement.elementType == JFormElementTypeDatePicker) {
            JFormElementPickerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementPickerCell"];
            cell.titleLabel.text = formElement.elementTitle;
            NSDate * value = [self.delegate formController:self valueForElement:formElement];
            if ([value isKindOfClass:[NSDate class]]) {
                cell.placeholderLabel.hidden = YES;
                cell.valueLabel.hidden = NO;
                NSDateFormatter * dateFormatter = formElement.dateFormatter;
                if (![dateFormatter isKindOfClass:[NSDateFormatter class]]) {
                    dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
                }
                cell.valueLabel.text = [dateFormatter stringFromDate:value];
            } else {
                cell.placeholderLabel.hidden = NO;
                cell.valueLabel.hidden = YES;
                cell.placeholderLabel.text = formElement.elementPlaceholder;
            }
            if ([self.delegate respondsToSelector:@selector(formController:descriptionForPickerElement:)]) {
                NSString * description = [self.delegate formController:self descriptionForPickerElement:formElement];
                if (description) cell.descriptionLabel.text = description;
                else description = @"";
            }
            return cell;
        }
        
        if (formElement.elementType == JFormElementTypeTextField) {
            JFormElementTextFieldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementTextFieldCell"];
            cell.titleLabel.text = formElement.elementTitle;
            NSString * value = [self.delegate formController:self valueForElement:formElement];
            cell.textField.text = value;
            cell.textField.placeholder = formElement.elementPlaceholder;
            return cell;
        }
        if (formElement.elementType == JFormElementTypeSwitch) {
            JFormElementSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementSwitchCell"];
            cell.titleLabel.text = formElement.elementTitle;
            NSNumber * value = [self.delegate formController:self valueForElement:formElement];
            cell.elementSwitch.on = value.boolValue;
            cell.placeholderLabel.text = formElement.elementPlaceholder;
            return cell;
        }
        if (formElement.elementType == JFormElementTypeSplitter) {
            JFormElementSplitterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementSplitterCell"];
            cell.titleLabel.text = formElement.elementTitle;
            return cell;
        }
    } else {
        
        if (formElement.elementType == JFormElementTypeCustomPicker) {
            NSInteger index = indexPath.row - 1;
            return [self.delegate formController:self cellForCustomPickerItemWithIndex:index forFormElement:formElement];
        }
        
        if (formElement.elementType == JFormElementTypePicker) {
            
        }
        
    }
    
    return nil;
}

@end

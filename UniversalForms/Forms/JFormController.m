//
//  JFormController.m
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormController.h"

@interface JFormController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, weak) JFormElement * selectedFormElement;

@property (nonatomic, strong) NSMutableArray * hiddenElements;

@end


@implementation JFormController {
    CGFloat initialBottomInset;
    UIResponder * lastResponder;
}

-(instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        
        
        initialBottomInset = self.tableView.contentInset.bottom;
        
        /// Keyboard events
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:self.tableView.window];
        // register for keyboard notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:self.tableView.window];

    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)setFormElements:(NSArray *)formElements
{
    _formElements = formElements;
    [self.tableView reloadData];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = initialBottomInset;
    [self.tableView setContentInset:insets];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = keyboardSize.height - initialBottomInset;
    [self.tableView setContentInset:insets];
    
}

- (void)hideKeyboard
{
    if (lastResponder && lastResponder.isFirstResponder) {
        [lastResponder resignFirstResponder];
    }
}

#pragma mark UIPickerView Data Source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger section = pickerView.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    
    if ([self.delegate respondsToSelector:@selector(formController:itemListForPickerFormElement:)]) {
        return [self.delegate formController:self itemListForPickerFormElement:formElement].count;
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger section = pickerView.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    
    if ([self.delegate respondsToSelector:@selector(formController:itemListForPickerFormElement:)]) {
        NSArray * items = [self.delegate formController:self itemListForPickerFormElement:formElement];
        if (items.count > row) {
            id object = items[row];
            return [NSString stringWithFormat:@"%@", object];
        }
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger section = pickerView.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    
    if ([self.delegate respondsToSelector:@selector(formController:pickerElement:didSelectItemWithIndex:)]){
        [self.delegate formController:self pickerElement:formElement didSelectItemWithIndex:row];
    }
    [self.tableView reloadData];
    
}

#pragma mark UIDatePicker

- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    NSInteger section = sender.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    if ([self.delegate respondsToSelector:@selector(formController:formElement:didSetValue:)]) {
        [self.delegate formController:self formElement:formElement didSetValue:sender.date];
    }
    [self.tableView reloadData];
    
    
}

#pragma mark UISwitch

- (void)switchChanged:(UISwitch *)sender
{
    NSInteger section = sender.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    if ([self.delegate respondsToSelector:@selector(formController:formElement:didSetValue:)]) {
        [self.delegate formController:self formElement:formElement didSetValue:@(sender.isOn)];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark UITextView

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger section = textView.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    if ([self.delegate respondsToSelector:@selector(formController:formElement:didSetValue:)]) {
        [self.delegate formController:self formElement:formElement didSetValue:textView.text];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    lastResponder = textView;
}

#pragma mark UITextField

- (void)textFieldChanged:(UITextField *)textField
{
    NSInteger section = textField.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    if ([self.delegate respondsToSelector:@selector(formController:formElement:didSetValue:)]) {
        [self.delegate formController:self formElement:formElement didSetValue:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    lastResponder = textField;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger section = textField.tag;
    JFormElement * formElement = [self.formElements objectAtIndex:section];
    
    if ([self.delegate respondsToSelector:@selector(formController:textField:shouldChangeCharactersInRange:replacementString:formElement:)]) {
        return [self.delegate formController:self textField:textField shouldChangeCharactersInRange:range replacementString:string formElement:formElement];
    }
    return true;
}

#pragma mark UITableView Data Source

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
    
    if ([self.delegate respondsToSelector:@selector(formController:isFormElementHidden:)]) {
        if ([self.delegate formController:self isFormElementHidden:formElement]) {
            return 0;
        }
    }
    
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
            cell.titleLabel.text = formElement.elementTitle;
            cell.textView.text = text;
            cell.textView.tag = indexPath.section;
            cell.textView.delegate = self;
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
            id value = [self.delegate formController:self valueForElement:formElement];
            if (value) {
                cell.placeholderLabel.hidden = YES;
                cell.valueLabel.hidden = NO;
                cell.valueLabel.text = [NSString stringWithFormat:@"%@", value];
            } else {
                cell.placeholderLabel.hidden = NO;
                cell.valueLabel.hidden = YES;
                cell.placeholderLabel.text = formElement.elementPlaceholder;
            }
            
            NSString * description = @"";
            if ([self.delegate respondsToSelector:@selector(formController:descriptionForPickerElement:)]) {
                description = [self.delegate formController:self descriptionForPickerElement:formElement];
            }
            
            if (description) cell.descriptionLabel.text = description;
            
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
            cell.textField.tag = indexPath.section;
            cell.textField.delegate = self;
            if (![cell.textField.allTargets containsObject:self]) {
                [cell.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            return cell;
        }
        if (formElement.elementType == JFormElementTypeSwitch) {
            JFormElementSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementSwitchCell"];
            cell.titleLabel.text = formElement.elementTitle;
            NSNumber * value = [self.delegate formController:self valueForElement:formElement];
            cell.elementSwitch.on = value.boolValue;
            cell.elementSwitch.tag = indexPath.section;
            if (![cell.elementSwitch.allTargets containsObject:self]) {
                [cell.elementSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
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
            JFormElementPickerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementPickerViewCell"];
            cell.pickerView.tag = indexPath.section;
            cell.pickerView.delegate = self;
            cell.pickerView.dataSource = self;
            NSString * value = [self.delegate formController:self valueForElement:formElement];
            if ([value isKindOfClass:[NSString class]] && [self.delegate respondsToSelector:@selector(formController:itemListForPickerFormElement:)]) {
                NSArray * items = [self.delegate formController:self itemListForPickerFormElement:formElement];
                NSInteger index = [items indexOfObject:value];
                [cell.pickerView selectRow:index inComponent:0 animated:false];
            }
            return cell;
        }
        if (formElement.elementType == JFormElementTypeDatePicker) {
            JFormElementDatePickerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JFormElementDatePickerViewCell"];
            if ([self.delegate respondsToSelector:@selector(formController:configureDatePicker:forFormElement:)]) {
                [self.delegate formController:self configureDatePicker:cell.datePickerView forFormElement:formElement];
            }
            cell.datePickerView.tag = indexPath.section;
            if (![cell.datePickerView.allTargets containsObject:self]) {
                [cell.datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            }
            NSDate * value = [self.delegate formController:self valueForElement:formElement];
            [cell.datePickerView setDate:value animated:false];
            return cell;
        }
        
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFormElement * formElement = [self.formElements objectAtIndex:indexPath.section];
    BOOL disabled = NO;
    if ([self.delegate respondsToSelector:@selector(formController:isFormElementDisabled:)]) {
        disabled = [self.delegate formController:self isFormElementDisabled:formElement];
    }
    cell.userInteractionEnabled = !disabled;
    cell.contentView.alpha = disabled?0.5:1;
    if ([cell isKindOfClass:[JFormElementCell class]] &&
        [self.delegate respondsToSelector:@selector(formController:prepareForDisplayCell:formElement:)]) {
        JFormElementCell * elementCell = (JFormElementCell *)cell;
        [self.delegate formController:self prepareForDisplayCell:elementCell formElement:formElement];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFormElement * formElement = [self.formElements objectAtIndex:indexPath.section];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (formElement.elementType == JFormElementTypePicker || formElement.elementType == JFormElementTypeDatePicker || formElement.elementType == JFormElementTypeCustomPicker) {
        [tableView beginUpdates];
        if ([self.selectedFormElement.elementName isEqual:formElement.elementName]) {
            self.selectedFormElement = nil;
        } else {
            self.selectedFormElement = formElement;
        }
        [tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath * pickerCellIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            /// Scroll to picker
            [tableView scrollToRowAtIndexPath:pickerCellIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        });
    } else {
        [tableView beginUpdates];
        self.selectedFormElement = nil;
        [tableView endUpdates];
    }
    if (formElement.elementType == JFormElementTypeSwitch) {
        JFormElementSwitchCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[JFormElementSwitchCell class]]) {
            [cell.elementSwitch setOn:!cell.elementSwitch.isOn animated:YES];
            [self switchChanged:cell.elementSwitch];
        }
    }
    if (formElement.elementType == JFormElementTypeTextView) {
        JFormElementTextViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[JFormElementTextViewCell class]]) {
            [cell.textView becomeFirstResponder];
        }
    } else if (formElement.elementType == JFormElementTypeTextField) {
        JFormElementTextFieldCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[JFormElementTextFieldCell class]]) {
            [cell.textField becomeFirstResponder];
        }
    } else {
        [self hideKeyboard];
    }
}


@end

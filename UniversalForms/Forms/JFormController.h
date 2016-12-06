//
//  JFormController.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JFormElement.h"
#import "JFormElementTextViewCell.h"
#import "JFormElementPickerCell.h"
#import "JFormElementTextFieldCell.h"
#import "JFormElementSwitchCell.h"
#import "JFormElementSplitterCell.h"

#import "JFormElementPickerViewCell.h"
#import "JFormElementDatePickerViewCell.h"


@import UIKit;

@protocol JFormControllerDelegate;



@interface JFormController : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <JFormControllerDelegate> delegate;
@property (nonatomic, strong) NSArray <JFormElement * > * formElements;

@end

@protocol JFormControllerDelegate <NSObject>

- (id)formController:(JFormController *)formController valueForElement:(JFormElement *)formElement;

@optional

- (NSString *)formController:(JFormController *)formController descriptionForPickerElement:(JFormElement *)formElement;
- (NSInteger)formController:(JFormController *)formController numberOfPickerItemsForFormElement:(JFormElement *)formElement;
- (CGFloat)formController:(JFormController *)formController heightForFormElement:(JFormElement *)formElement; // return -1 for default
- (BOOL)formController:(JFormController *)formController isFormElementHidden:(JFormElement *)formElement;
- (BOOL)formController:(JFormController *)formController isFormElementDisabled:(JFormElement *)formElement;

- (UITableViewCell *)formController:(JFormController *)formController customCellForFormElement:(JFormElement *)formElement;

- (CGFloat)formController:(JFormController *)formController heightForCustomPickerItemWithIndex:(NSInteger)itemIndex forFormElement:(JFormElement *)formElement;
- (UITableViewCell *)formController:(JFormController *)formController cellForCustomPickerItemWithIndex:(NSInteger)itemIndex forFormElement:(JFormElement *)formElement;
- (void)formController:(JFormController *)formController configureDatePicker:(UIDatePicker *)datePicker forFormElement:(JFormElement *)formElement;
- (NSArray <NSString *> *)formController:(JFormController *)formController itemListForPickerFormElement:(JFormElement *)formElement;

- (void)formController:(JFormController *)formController prepareForDisplayCell:(JFormElementCell *)cell formElement:(JFormElement *)formElement;

- (BOOL)formController:(JFormController *)formController textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formElement:(JFormElement *)formElement;

/// For JFormElementTypePicker, JFormElementTypeCustomPicker
- (void)formController:(JFormController *)formController pickerElement:(JFormElement *)formElement didSelectItemWithIndex:(NSInteger)selectedIndex;


/// For JFormElementTypeDatePicker, JFormElementTypeSwitch, JFormElementTypeTextField, JFormElementTypeTextView
- (void)formController:(JFormController *)formController formElement:(JFormElement *)formElement didSetValue:(id)value;


@end


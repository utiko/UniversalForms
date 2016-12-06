//
//  ViewController.m
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "ViewController.h"

#import "JFormController.h"

@interface ViewController () <JFormControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) JFormController * formController;

@property (nonatomic, strong) NSArray * fieldsCountItems;

@property (nonatomic, readonly) NSArray * gameFormatTitles;
@property (nonatomic, readonly) NSArray * gameFormatValues;

@property (nonatomic, strong) NSArray * teamsInPlayoffTitles;
@property (nonatomic, strong) NSArray * teamsInPlayoffValues;


@end

#define fields_count_element @"fields_count_element"
#define game_format_element @"game_format_element"
#define playoffs_element @"playoffs_element"
#define teams_in_playoff_element @"teams_in_playoff_element"
#define teams_in_playoff_splitter_element @"teams_in_playoff_splitter_element"
#define description_element @"description_element"
#define phone_element @"phone_element"
#define last_splitter @"last_splitter"

@implementation ViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formController = [[JFormController alloc] initWithTableView:self.tableView];
    self.formController.delegate = self;
    
    NSMutableArray <JFormElement * > * formElements  = [NSMutableArray array];
    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];
    
    /// TURFS COUNT
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypePicker name:fields_count_element title:@"TURFS COUNT"]];
    NSMutableArray * fieldsCountItems = [NSMutableArray array];
    for (NSInteger i=1; i<=8; i++) {
        [fieldsCountItems addObject:@(i)];
    }
    _fieldsCountItems = fieldsCountItems;
    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];
    
    /// GAME FORMAT
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypePicker name:game_format_element title:@"GAME FORMAT"]];
    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];
    
    /// PLAYOFFS
    JFormElement * playoffsElement = [JFormElement formElementWithType:JFormElementTypeSwitch name:playoffs_element title:@"PLAYOFFS"];
    playoffsElement.elementPlaceholder = @"Enable Playoffs";
    [formElements addObject:playoffsElement];
    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:teams_in_playoff_splitter_element]];
    
    /// TEAMS IN PLAYOFF
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypePicker name:teams_in_playoff_element title:@"TEAMS IN PLAYOFF"]];
    self.teamsInPlayoffTitles = @[@"Top 4", @"Top 2"];
    self.teamsInPlayoffValues = @[@(4), @(2)];
    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];
    
    /// Description
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeTextView name:description_element title:@"DESCRIPTIONN"]];
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];
    
    /// Phone number
    JFormElement * phoneElement = [JFormElement formElementWithType:JFormElementTypeTextField name:phone_element title:@"PHONE NUMBER"];
    phoneElement.elementPlaceholder = @"(123) 456-78-90";
    [formElements addObject:phoneElement];

    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:nil]];

    /// GAME FORMAT
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypePicker name:game_format_element title:@"GAME FORMAT"]];
    

    
    [formElements addObject:[JFormElement formElementWithType:JFormElementTypeSplitter name:last_splitter height:40]];
    
    
    self.formController.formElements = formElements;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Properties

-(NSArray *)gameFormatTitles
{
    if (self.fieldsCount == 1) {
        return @[@"Round-robin", @"Moderate", @"Competitive", @"Ultra Competitive"];
    } else {
        return @[@"Round-robin"];
    }
}

-(NSArray *)gameFormatValues
{
    if (self.fieldsCount == 1) {
        return @[@(JChallengeGameFormatRoundRobin), @(JChallengeGameFormatModerate), @(JChallengeGameFormatCompetitive), @(JChallengeGameFormatUltraCompetitive)];
    } else {
        return @[@(JChallengeGameFormatRoundRobin)];
    }
}

#pragma mark JFormController delegate

-(id)formController:(JFormController *)formController valueForElement:(JFormElement *)formElement
{
    if ([formElement.elementName isEqual:fields_count_element]) {
        return @(self.fieldsCount);
    }
    if ([formElement.elementName isEqual:game_format_element]) {
        NSInteger index = [self.gameFormatValues indexOfObject:@(self.gameRules.gameFormat)];
        NSString * value = [self.gameFormatTitles objectAtIndex:index];
        return value;
    }
    if ([formElement.elementName isEqual:playoffs_element]) {
        return @(self.gameRules.playoffsEnebled);
    }
    if ([formElement.elementName isEqual:teams_in_playoff_element]) {
        NSUInteger index = [self.teamsInPlayoffValues indexOfObject:@(self.gameRules.teamsInPlayoff)];
        if (index < self.teamsInPlayoffTitles.count) {
            NSString * value = [self.teamsInPlayoffTitles objectAtIndex:index];
            return value;
        }
        return nil;
    }
    if ([formElement.elementName isEqual:description_element]) {
        return self.gameRules.rulesDescription;
    }
    
    return nil;
}

-(NSArray<NSString *> *)formController:(JFormController *)formController itemListForPickerFormElement:(JFormElement *)formElement
{
    if ([formElement.elementName isEqual:fields_count_element]) {
        return self.fieldsCountItems;
    }
    if ([formElement.elementName isEqual:game_format_element]) {
        return self.gameFormatTitles;
    }
    if ([formElement.elementName isEqual:teams_in_playoff_element]) {
        return self.teamsInPlayoffTitles;
    }
    return nil;
}

-(void)formController:(JFormController *)formController pickerElement:(JFormElement *)formElement didSelectItemWithIndex:(NSInteger)selectedIndex
{
    if ([formElement.elementName isEqual:fields_count_element]) {
        self.fieldsCount = [[self.fieldsCountItems objectAtIndex:selectedIndex] integerValue];
        if (self.fieldsCount > 1 && !self.gameRules.roundRobin) {
            self.gameRules.gameFormat = JChallengeGameFormatRoundRobin;
        }
    }
    
    if ([formElement.elementName isEqual:game_format_element]) {
        self.gameRules.gameFormat = [[self.gameFormatValues objectAtIndex:selectedIndex] integerValue];
        if (!self.gameRules.roundRobin) {
            if (self.gameRules.playoffsEnebled) {
                self.gameRules.playoffsEnebled = NO;
            }
        }
    }
    
    if ([formElement.elementName isEqual:teams_in_playoff_element]) {
        self.gameRules.teamsInPlayoff = [[self.teamsInPlayoffValues objectAtIndex:selectedIndex] integerValue];
    }
    
}


-(void)formController:(JFormController *)formController formElement:(JFormElement *)formElement didSetValue:(id)value
{
    if ([formElement.elementName isEqual:playoffs_element]) {
        self.gameRules.playoffsEnebled = [value boolValue];
        if (self.gameRules.playoffsEnebled && self.gameRules.teamsInPlayoff == 0) {
            self.gameRules.teamsInPlayoff = 4;
        }
    }
    
    if ([formElement.elementName isEqual:description_element]) {
        self.gameRules.rulesDescription = value;
    }
    
}

-(BOOL)formController:(JFormController *)formController isFormElementHidden:(JFormElement *)formElement
{
    if ([formElement.elementName isEqual:teams_in_playoff_element] || [formElement.elementName isEqual:teams_in_playoff_splitter_element]) {
        return !self.gameRules.playoffsEnebled;
    }
    return NO;
}

-(BOOL)formController:(JFormController *)formController isFormElementDisabled:(JFormElement *)formElement
{
    if ([formElement.elementName isEqual:playoffs_element]) {
        return !self.gameRules.roundRobin;
    }
    return NO;
}


-(void)formController:(JFormController *)formController prepareForDisplayCell:(JFormElementCell *)cell formElement:(JFormElement *)formElement
{
    cell.borderView.hidden = [formElement.elementName isEqual:last_splitter];
    if ([cell isKindOfClass:[JFormElementTextFieldCell class]]) {
        ((JFormElementTextFieldCell *)cell).textField.keyboardType = [formElement.elementName isEqual:phone_element]?UIKeyboardTypeNumberPad:UIKeyboardTypeDefault;
    }
}

-(BOOL)formController:(JFormController *)formController textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formElement:(JFormElement *)formElement
{
    if ([formElement.elementName isEqual:phone_element]) {
        NSString* totalString = [NSString stringWithFormat:@"%@%@",textField.text,string];
        if (range.length == 1) {
            // Delete button was hit.. so tell the method to delete the last char.
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
        } else {
            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO];
        }
        
        //self.timeslot.timeslotOrganizerPhoneNumber = textField.text;
        return false;
    }
    return true;
}


#pragma mark Helper

- (NSString*)formatPhoneNumber:(NSString*)simpleNumber deleteLastChar:(BOOL)deleteLastChar
{
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    if(deleteLastChar) {
        // should we delete the last digit?
        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
    }
    
    // 123 456 7890
    // format the number.. if it's less than 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"($1) $2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"($1) $2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

@end

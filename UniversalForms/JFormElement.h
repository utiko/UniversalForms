//
//  JBaseFormElement.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef enum : NSUInteger {
    JFormElementTypeSplitter,
    JFormElementTypePicker,
    JFormElementTypeDatePicker,
    JFormElementTypeCustomPicker,
    JFormElementTypeSwitch,
    JFormElementTypeTextField,
    JFormElementTypeTextView,
    JFormElementTypeCusomCell,
} JFormElementType;


@interface JFormElement : NSObject

+ (JFormElement *)formElementWithType:(JFormElementType)type name:(NSString *)name;
+ (JFormElement *)formElementWithType:(JFormElementType)type name:(NSString *)name height:(CGFloat)height;

@property (nonatomic) CGFloat height;
@property (nonatomic) JFormElementType elementType;
@property (nonatomic, strong) NSString * elementName;
@property (nonatomic, strong) NSString * elementTitle;
@property (nonatomic, strong) NSString * elementPlaceholder;

@property (nonatomic, strong) NSDateFormatter * dateFormatter;


@end

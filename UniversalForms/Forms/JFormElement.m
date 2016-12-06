//
//  JBaseFormElement.m
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "JFormElement.h"

@implementation JFormElement

+(JFormElement *)formElementWithType:(JFormElementType)type name:(NSString *)name
{
    JFormElement * element = [[JFormElement alloc] init];
    element.elementName = name;
    element.elementType = type;
    return element;
}

+(JFormElement *)formElementWithType:(JFormElementType)type name:(NSString *)name title:(NSString *)title
{
    JFormElement * element = [[JFormElement alloc] init];
    element.elementTitle = title;
    element.elementName = name;
    element.elementType = type;
    return element;
}

+(JFormElement *)formElementWithType:(JFormElementType)type name:(NSString *)name height:(CGFloat)height
{
    JFormElement * element = [[JFormElement alloc] init];
    element.height = height;
    element.elementName = name;
    element.elementType = type;
    return element;
    
}


@end

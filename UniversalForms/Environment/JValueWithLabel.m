//
//  JValueWithLabel.m
//  Turfmapp
//
//  Created by Kostia Kolesnyk on 3/22/16.
//  Copyright © 2016 Turfmapp Team. All rights reserved.
//

#import "JValueWithLabel.h"
#import "NSDictionary+Values.h"

@implementation JValueWithLabel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.value = [dict stringForKey:@"value"];
        self.label = [dict stringForKey:@"label"];
    }
    return self;
}

- (instancetype)initWithValue:(NSString *)value
{
    self = [super init];
    if (self) {
        self.value = value;
        self.label = value.capitalizedString;
    }
    return self;
}

+ (JValueWithLabel *)valueWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        JValueWithLabel * item = [[JValueWithLabel alloc] initWithDictionary:dict];
        if (item.value) return item;
    }
    return nil;
}

+ (JValueWithLabel *)value:(NSString *)value
{
    return [[JValueWithLabel alloc] initWithValue:value];
}

+ (JValueWithLabel *)value:(NSString *)value withLabel:(NSString *)label
{
    JValueWithLabel * item = [[JValueWithLabel alloc] initWithValue:value];
    item.label = label;
    return item;
}

+ (NSArray<JValueWithLabel *> *)listWithValues:(NSArray *)values labels:(NSArray *)labels
{
    NSMutableArray <JValueWithLabel *> * list = [NSMutableArray array];
    for (NSInteger i = 0; i < values.count; i++) {
        JValueWithLabel * value;
        if (labels.count > i) {
            value = [JValueWithLabel value:values[i] withLabel:labels[i]];
        } else {
            value = [JValueWithLabel value:values[i]];
        }
        [list addObject:value];
    }
    return [NSArray arrayWithArray:list];
}

-(id)copyWithZone:(NSZone *)zone
{
    JValueWithLabel * item = [[JValueWithLabel allocWithZone:zone] init];
    item.value = self.value;
    item.label = self.label;
    return item;
}

@end

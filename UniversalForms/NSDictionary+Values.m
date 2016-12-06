//
//  NSDictionary+Values.m
//  Turfmapp
//
//  Created by Костя Колесник on 14.12.14.
//  Copyright (c) 2014 Turfmapp Team. All rights reserved.
//

#import "NSDictionary+Values.h"
#import "NSDate+formatDate.h"

@implementation NSDictionary (Values)

- (NSString *)stringForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    if (!value) return nil;
    if ([value isEqual:[NSNull null]]) return nil;
    return [NSString  stringWithFormat:@"%@", value];
}

-(NSInteger)integerForKey:(NSString *)key
{
    @try {
        id value = [self objectForKey:key];
        if (!value) return 0;
        if ([value isEqual:[NSNull null]]) return 0;
        return [value integerValue];
    }
    @catch (NSException *exception) {
        return 0;
    }
}

-(BOOL)boolForKey:(NSString *)key
{
    @try {
        id value = [self objectForKey:key];
        if (!value) return NO;
        if ([value isEqual:[NSNull null]]) return NO;
        return [value boolValue];
    }
    @catch (NSException *exception) {
        return NO;
    }
}

-(CGFloat)floatForKey:(NSString *)key
{
    @try {
        id value = [self objectForKey:key];
        if (!value) return 0;
        if ([value isEqual:[NSNull null]]) return 0;
        return [value floatValue];
    }
    @catch (NSException *exception) {
        return 0;
    }
}

- (NSDate *)dateForISOValueKey:(NSString *)key
{
    NSString * strValue = [self stringForKey:key];
    if (strValue.length > 0) {
        return [NSDate dateFromISO8601String:strValue];
    }
    return nil;
}

- (NSDate *)dateForUnixTimeValueKey:(NSString *)key
{
    NSInteger value = [self integerForKey:key];
    if (value > 0) {
        return [NSDate dateWithTimeIntervalSince1970:value];
    }
    return nil;
}


@end

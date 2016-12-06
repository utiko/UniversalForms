//
//  NSDate+formatDate.m
//  Turfmapp
//
//  Created by Kostia on 10.12.15.
//  Copyright © 2015 Turfmapp Team. All rights reserved.
//

#import "NSDate+formatDate.h"

@implementation NSDate (formatDate)

- (NSString *)formatedTimeWithStyle:(NSDateFormatterStyle)style timezone:(NSTimeZone *)timezone
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setTimeStyle:style];
    [formater setTimeZone:timezone];
    NSString *currentLocalization = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    [formater setLocale:[NSLocale localeWithLocaleIdentifier:currentLocalization]];
    return [formater stringFromDate:self];
}

- (NSString *)formatedDateWithStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateStyle:style];
    NSString *currentLocalization = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    [formater setLocale:[NSLocale localeWithLocaleIdentifier:currentLocalization]];
    return [formater stringFromDate:self];
}

- (NSString *)formatedWithTextFormat:(NSString *)format
{
    
    return [self formatedDateWithTextFormat:format timezone:[NSTimeZone defaultTimeZone]];
}

- (NSString *)formatedDateWithTextFormat:(NSString *)format timezone:(NSTimeZone *)timezone
{
    return [self formatedDateWithTextFormat:format calendar:[NSCalendar currentCalendar] timezone:timezone];
}


- (NSString *)formatedDateWithTextFormat:(NSString *)format calendar:(NSCalendar *)calendar timezone:(NSTimeZone *)timezone
{
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    [formater setCalendar: calendar];
    [formater setTimeZone:timezone];
    NSString *currentLocalization = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    [formater setLocale:[NSLocale localeWithLocaleIdentifier:currentLocalization]];
    return [formater stringFromDate:self];
}


+ (NSDate *)dateFromISO8601String:(NSString *)iso8601 {
    
    
    // Return nil if nil is given
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) {
        return nil;
    }
    
    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }
    
    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]]) {
        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }
        
        struct tm tm;
        char newStr[25] = "";
        BOOL hasTimezone = NO;
        
        // 2014-03-30T09:13:00Z
        if (len == 20 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
        }
        
        // 2014-03-30T09:13:00-07:00
        else if (len == 25 && str[22] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }
        
        // 2014-03-30T09:13:00.000Z
        else if (len == 24 && str[len - 1] == 'Z') {
            strncpy(newStr, str, 19);
        }
        
        // 2014-03-30T09:13:00.000-07:00
        else if (len == 29 && str[26] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }
        
        // Poorly formatted timezone
        else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }
        
        // Timezone
        size_t l = strlen(newStr);
        if (hasTimezone) {
            strncpy(newStr + l, str + len - 6, 3);
            strncpy(newStr + l + 3, str + len - 2, 2);
        } else {
            strncpy(newStr + l, "+0000", 5);
        }
        
        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;
        
        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }
        
        time_t t;
        t = mktime(&tm);
        
        return [NSDate dateWithTimeIntervalSince1970:t];
    }
    
    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}





@end

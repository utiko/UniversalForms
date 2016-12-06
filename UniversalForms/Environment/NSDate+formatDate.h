//
//  NSDate+formatDate.h
//  Turfmapp
//
//  Created by Kostia on 10.12.15.
//  Copyright © 2015 Turfmapp Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (formatDate)

- (NSString *)formatedDateWithStyle:(NSDateFormatterStyle)style;
- (NSString *)formatedTimeWithStyle:(NSDateFormatterStyle)style timezone:(NSTimeZone *)timezone;
- (NSString *)formatedWithTextFormat:(NSString *)format;
- (NSString *)formatedDateWithTextFormat:(NSString *)format timezone:(NSTimeZone *)timezone;
- (NSString *)formatedDateWithTextFormat:(NSString *)format calendar:(NSCalendar *)calendar timezone:(NSTimeZone *)timezone;


+ (NSDate *)dateFromISO8601String:(NSString *)iso8601String;

@end

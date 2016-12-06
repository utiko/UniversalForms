//
//  NSDictionary+Values.h
//  Turfmapp
//
//  Created by Костя Колесник on 14.12.14.
//  Copyright (c) 2014 Turfmapp Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface NSDictionary (Values)

- (NSString *)stringForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (CGFloat)floatForKey:(NSString *)key;
- (NSDate *)dateForISOValueKey:(NSString *)key;
- (NSDate *)dateForUnixTimeValueKey:(NSString *)key;

@end

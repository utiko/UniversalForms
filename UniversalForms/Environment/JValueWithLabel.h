//
//  JValueWithLabel.h
//  Turfmapp
//
//  Created by Kostia Kolesnyk on 3/22/16.
//  Copyright © 2016 Turfmapp Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JValueWithLabel : NSObject <NSCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (JValueWithLabel *)valueWithDict:(NSDictionary *)dict;
+ (JValueWithLabel *)value:(NSString *)value;
+ (JValueWithLabel *)value:(NSString *)value withLabel:(NSString *)label;
+ (NSArray <JValueWithLabel * > *)listWithValues:(NSArray *)values labels:(NSArray *)labels;


@property (nonatomic, strong) NSString * value;
@property (nonatomic, strong) NSString * label;

@end

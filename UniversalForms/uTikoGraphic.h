//
//  uTikoGraphic.h
//  MegaSOS
//
//  Created by Kostya Kolesnyk on 30.05.13.
//  Copyright (c) 2013 Kostya Kolesnyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha;

@end

@interface UIImage (workWithImages)

-(UIImage *)resizeToSize:(CGSize)newSize;
-(UIImage *)resizeToWidth:(float)width;
-(UIImage *)resizeToMaximumSize:(float)size;
-(UIImage *)resizeProportionalWithCropToSize:(CGSize)newSize;
-(UIImage *)resizeProportionalWithCropToSize:(CGSize)newSize center:(BOOL)center;
-(UIImage *)cropToSize:(CGSize)newSize;
-(UIImage *)cropLeftTopToSize:(CGSize)newSize;

-(UIImage *)rotate:(UIImage *)image radians:(float)rads;
//- (UIImage*) blurWithRadius:(NSInteger )radius;

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@interface UIImageView (setImageAnimation)

- (void)setImage:(UIImage *)image withAnimation:(BOOL)animation;

@end


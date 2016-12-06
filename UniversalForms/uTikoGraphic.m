//
//  uTikoGraphic.m
//  MegaSOS
//
//  Created by Kostya Kolesnyk on 30.05.13.
//  Copyright (c) 2013 Kostya Kolesnyk. All rights reserved.
//

#import "uTikoGraphic.h"
//#import "GPUImage.h"

@implementation UIColor (hexColor)

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(UIColor*) colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha
{
    UIColor * color = [UIColor colorWithHexString:hex];
    return [color colorWithAlphaComponent:alpha];
}

@end

@implementation UIImage (workWithImages)

-(UIImage *)resizeToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)resizeToWidth:(float)width
{
    CGFloat height = self.size.height / self.size.width * width;
    return [self resizeToSize:CGSizeMake(width, height)];
}

-(UIImage *)resizeToMaximumSize:(float)size
{
    CGFloat width;
    CGFloat height;
    if (self.size.width > self.size.height) {
        width = size;
        height = self.size.height / self.size.width * size;
    } else {
        height = size;
        width = self.size.width / self.size.height * size;
    }
    return [self resizeToSize:CGSizeMake(width, height)];
}

-(UIImage *)resizeProportionalWithCropToSize:(CGSize)newSize
{
    return [self resizeProportionalWithCropToSize:newSize center:YES];
}

-(UIImage *)resizeProportionalWithCropToSize:(CGSize)newSize center:(BOOL)center
{
    CGSize originalSize = self.size;
    CGSize firstSize;
    if (originalSize.width / originalSize.height > newSize.width / newSize.height)
    {
        firstSize = CGSizeMake(newSize.height / originalSize.height * originalSize.width, newSize.height);
    }
    else
    {
        firstSize = CGSizeMake(newSize.width, newSize.width / originalSize.width * originalSize.height);
    }
    UIImage * resizedImage = [self resizeToSize:firstSize];
    UIImage * result;
    if (center) {
        result = [resizedImage cropToSize:newSize];
    } else {
        result = [resizedImage cropLeftTopToSize:newSize];
    }
    return result;
}

-(UIImage *)cropToSize:(CGSize)newSize
{
    CGRect cropRect = CGRectMake((self.size.width - newSize.width) / 2, (self.size.height - newSize.height) / 2, newSize.width, newSize.height);
    if (self.scale > 1.0f) {
        cropRect = CGRectMake(cropRect.origin.x * self.scale,
                              cropRect.origin.y * self.scale,
                              cropRect.size.width * self.scale,
                              cropRect.size.height * self.scale);
    }
    CGImageRef sgImage = [self CGImage];
    CGImageRef imageRef = CGImageCreateWithImageInRect(sgImage, cropRect);
    UIImage * image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

-(UIImage *)cropLeftTopToSize:(CGSize)newSize
{
    CGRect cropRect = CGRectMake(0, 0, newSize.width, newSize.height);
    if (self.scale > 1.0f) {
        cropRect = CGRectMake(cropRect.origin.x * self.scale,
                              cropRect.origin.y * self.scale,
                              cropRect.size.width * self.scale,
                              cropRect.size.height * self.scale);
    }
    CGImageRef sgImage = [self CGImage];
    CGImageRef imageRef = CGImageCreateWithImageInRect(sgImage, cropRect);
    UIImage * image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)rotate:(UIImage *)image radians:(float)rads
{
    CGFloat newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide/2, newSide/2);
    CGContextRotateCTM(ctx, rads);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,size.width, size.height),image.CGImage);
    //CGContextTranslateCTM(ctx, [image size].width/2, [image size].height/2);
    
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

static CGFloat edgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = edgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*- (UIImage*) blurWithRadius:(NSInteger )radius
{
    GPUImageGaussianBlurFilter *blurFilter = [GPUImageGaussianBlurFilter new];
    blurFilter.blurRadiusInPixels = radius;
    blurFilter.blurPasses = 1;
    UIImage *result = [blurFilter imageByFilteringImage:self];
    return result;
}*/

@end

@implementation UIImageView (setImageAnimation)

- (void)setImage:(UIImage *)image withAnimation:(BOOL)animation
{
    if (animation) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.layer addAnimation:transition forKey:nil];
    }
    self.image = image;
}

@end




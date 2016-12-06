//
//  JBorderedView.h
//  Turfmapp
//
//  Created by Костя Колесник on 25.11.14.
//  Copyright (c) 2014 Turfmapp Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JBorderedView : UIView

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor * borderColor;
@property (nonatomic) IBInspectable BOOL leftBorder;
@property (nonatomic) IBInspectable BOOL rightBorder;
@property (nonatomic) IBInspectable BOOL topBorder;
@property (nonatomic) IBInspectable BOOL bottomBorder;


@end

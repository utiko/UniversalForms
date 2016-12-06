//
//  ViewController.h
//  UniversalForms
//
//  Created by Kostia Kolesnyk on 12/2/16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChallengeGameRules.h"

@interface ViewController : UIViewController

@property (nonatomic, copy) JChallengeGameRules * gameRules;
@property (nonatomic) NSInteger fieldsCount;

@end


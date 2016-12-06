//
//  MainViewController.m
//  UniversalForms
//
//  Created by Kostia on 06.12.16.
//  Copyright © 2016 Kostia Kolesnyk. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) JChallengeGameRules * gameRules;
@property (nonatomic) NSInteger fieldsCount;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameRules = [[JChallengeGameRules alloc] init];
    self.gameRules.gameFormat = JChallengeGameFormatCompetitive;
    self.gameRules.maxWins = 3;
    self.gameRules.maxGoals = 3;
    self.gameRules.gameTime = 5;
    self.gameRules.permissions = @"all";
    //self.gameRules.playoffsEnebled = YES;
    self.fieldsCount = 1;
    
    [self showRules];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRules
{
    NSMutableArray * lines = [NSMutableArray array];
    [lines addObject:[NSString stringWithFormat:@"Fields count: %@", @(self.fieldsCount)]];
    [lines addObject:[NSString stringWithFormat:@"Format: %@", self.gameRules.gameFormatStrKey]];
    [lines addObject:[NSString stringWithFormat:@"Max wins: %@", @(self.gameRules.maxWins)]];
    [lines addObject:[NSString stringWithFormat:@"Max goals: %@", @(self.gameRules.maxGoals)]];
    [lines addObject:[NSString stringWithFormat:@"Game time: %@", @(self.gameRules.gameTime)]];
    [lines addObject:[NSString stringWithFormat:@"Permissions: %@", self.gameRules.permissions]];
    self.label.text = [lines componentsJoinedByString:@"\n"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ViewController class]]) {
        ViewController * vc = (ViewController *)segue.destinationViewController;
        vc.gameRules = self.gameRules;
        vc.fieldsCount = 1;
    }
}

@end

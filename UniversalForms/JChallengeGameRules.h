//
//  JChallengeGameRules.h
//  Turfmapp
//
//  Created by Kostia Kolesnyk on 26.05.15.
//  Copyright (c) 2015 Turfmapp Team. All rights reserved.
//

#import <Foundation/Foundation.h>


enum {
    JChallengeGameFormatRoundRobin,
    JChallengeGameFormatModerate,
    JChallengeGameFormatCompetitive,
    JChallengeGameFormatUltraCompetitive
};

typedef NSUInteger JChallengeGameFormat;


#define JChallengeGameFormatStrings @[@"round_robin", @"moderate", @"competitive", @"ultra_competitive"]

@interface JChallengeGameRules : NSObject <NSCopying>

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic) NSInteger gameTime;
@property (nonatomic) NSInteger maxGoals;
@property (nonatomic) NSInteger maxWins;
@property (nonatomic, strong) NSArray * rewards;
@property (nonatomic, readonly) BOOL roundRobin;
@property (nonatomic, readonly) NSAttributedString * rulesAttributedString;
@property (nonatomic, strong) NSString * permissions; //all|view_only    Can view and manage all actions|View only
@property (nonatomic) JChallengeGameFormat gameFormat;
@property (nonatomic , readonly) NSString * gameFormatStrKey;

@property (nonatomic) BOOL playoffsEnebled;
@property (nonatomic) NSInteger teamsInPlayoff;
@property (nonatomic, strong) NSString * rulesDescription;

@end

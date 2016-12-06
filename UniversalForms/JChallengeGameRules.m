//
//  JChallengeGameRules.m
//  Turfmapp
//
//  Created by Kostia Kolesnyk on 26.05.15.
//  Copyright (c) 2015 Turfmapp Team. All rights reserved.
//

#import "JChallengeGameRules.h"
//#import "JChallengePlayerPointsItem.h"
#import "NSDictionary+Values.h"
//#import "NSMutableAttributedString+FormatText.h"

#import "uTikoGraphic.h"

@implementation JChallengeGameRules

-(instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        //self.timeslotID = timeslotID;
        self.maxGoals = [dict integerForKey:@"max_goals"];
        self.maxWins = [dict integerForKey:@"max_wins"];
        self.gameTime = [dict integerForKey:@"game_time"];
        NSArray * rewardsData = [dict objectForKey:@"rewards"];
        NSMutableArray * rewards = [NSMutableArray array];
        for (NSDictionary * rewardData in rewardsData) {
            if ([rewardData isKindOfClass:[NSDictionary class]]) {
                //JChallengePlayerPointsItem * reward = [[JChallengePlayerPointsItem alloc] initWithDictionary:rewardData];
                //[rewards addObject:reward];
            }
        }
        self.rewards = [NSArray arrayWithArray:rewards];
        
        NSDictionary * permissionsSettings = [dict objectForKey:@"permission_settings"];
        if ([permissionsSettings isKindOfClass:[NSDictionary class]]) {
            self.permissions = [permissionsSettings stringForKey:@"value"];
        }
        
        NSString * strGameFormat = [dict stringForKey:@"game_format"];
        self.gameFormat = [JChallengeGameFormatStrings indexOfObject:strGameFormat];
        self.playoffsEnebled = [dict boolForKey:@"playoffs"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    JChallengeGameRules * copy = [[JChallengeGameRules alloc] init];
    //copy.timeslotID = self.timeslotID;
    copy.maxGoals = self.maxGoals;
    copy.maxWins = self.maxWins;
    copy.gameTime = self.gameTime;
    copy.gameFormat = self.gameFormat;
    copy.permissions = self.permissions;
    copy.playoffsEnebled = self.playoffsEnebled;
    return copy;
}


-(NSAttributedString *)rulesAttributedString
{
    if (self.gameFormat == JChallengeGameFormatRoundRobin) {
        NSString * text = NSLocalizedString(@"-  Teams play the same number of games\n-  Schedule is predetermined", @"");
        return [[NSAttributedString alloc] initWithString: NSLocalizedString(text, @"")];
    } else {
        NSString * text = @"";
        if (self.gameFormat != JChallengeGameFormatModerate) {
            NSString * point = NSLocalizedString(@"-  First to %d goals or %d minutes\n", @"");
            text = [NSString stringWithFormat:point, self.maxGoals, self.gameTime / 60];
        }
        text = [text stringByAppendingString: NSLocalizedString(@"-  When time's up, team with most goals wins\n-  If tie game, both teams come off\n", @"")];
        if (self.gameFormat == JChallengeGameFormatUltraCompetitive) {
            text = [text stringByAppendingString: NSLocalizedString(@"-  Winner stays", @"")];
        } else {
            NSString * point = NSLocalizedString(@"-  Winner stays up to %d consecutive games", @"");
            text = [text stringByAppendingString:[NSString stringWithFormat:point, self.maxWins]];
        }
        NSMutableAttributedString * attrText = [[NSMutableAttributedString alloc] initWithString:text];
        //[attrText formatWithSelectString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:13]}];
        
        //[attrText formatWithSelectString:NSLocalizedString(@"or", @"") attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"7FAE65"]}];
        //self.rulesLabel.attributedText = self.g;
        return attrText;
    }
}


-(BOOL)roundRobin
{
    return self.gameFormat == JChallengeGameFormatRoundRobin;
}


-(NSString *)gameFormatStrKey
{
    return [JChallengeGameFormatStrings objectAtIndex:self.gameFormat];
}


@end

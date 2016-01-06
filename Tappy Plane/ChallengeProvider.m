//
//  ChallengeProvider.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/6/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import "ChallengeProvider.h"
#import "Constants.h"

@implementation ChallengeItem

+ (instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position
{
    ChallengeItem *item = [[ChallengeItem alloc] init];
    item.obstacleKey = key;
    item.position = position;
    return item;
}

@end

@interface ChallengeProvider()

@property (nonatomic) NSMutableArray *challenges;

@end

@implementation ChallengeProvider

+ (instancetype)getProvider {
    
    static ChallengeProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadChallenges];
    });
    
    return sharedInstance;
}

- (NSArray*)getRandomChallenge {
    return [self.challenges objectAtIndex:arc4random_uniform((uint)self.challenges.count)];
}

-(void)loadChallenges
{
    _challenges = [NSMutableArray array];
    
//    // Challenge 1
      NSMutableArray *challenge = [NSMutableArray array];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(0, 95)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainDown andPosition:CGPointMake(143, 250)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(10, 270)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(152, 55)]];
    [self.challenges addObject:challenge];
    
    // Challenge 2
    challenge = [NSMutableArray array];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(90, 25)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainDownAlternate andPosition:CGPointMake(0, 232)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(100, 243)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(152, 205)]];
    [self.challenges addObject:challenge];
    
    // Challenge 3
    challenge = [NSMutableArray array];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainUp andPosition:CGPointMake(0, 82)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainUpAlternate andPosition:CGPointMake(122, 0)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyMountainDown andPosition:CGPointMake(85, 320)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(10, 213)]];
    [challenge addObject:[ChallengeItem challengeItemWithKey:kTPKeyCollectableStar andPosition:CGPointMake(81, 116)]];
    [self.challenges addObject:challenge];
}

@end

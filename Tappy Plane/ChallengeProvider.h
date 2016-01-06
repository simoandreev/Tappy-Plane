//
//  ChallengeProvider.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/6/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ChallengeItem : NSObject

@property (nonatomic) NSString *obstacleKey;

@property (nonatomic) CGPoint position;

+ (instancetype)challengeItemWithKey:(NSString*)key andPosition:(CGPoint)position;

@end

@interface ChallengeProvider : NSObject

+ (instancetype)getProvider;

- (NSArray*)getRandomChallenge;

@end

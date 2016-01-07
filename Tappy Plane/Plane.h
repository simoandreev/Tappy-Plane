//
//  Plane.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/15/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundManager.h"

@interface Plane : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL accelerating;
@property (nonatomic) BOOL crashed;

- (void)setRandomColour;
- (void)update;
- (void)collide:(SKPhysicsBody*)body;
- (void)reset;

@end

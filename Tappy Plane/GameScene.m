//
//  GameScene.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/15/15.
//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import "GameScene.h"
#import "Plane.h"

@interface GameScene ()

@property (nonatomic) Plane *player;
@property (nonatomic) SKNode *world;

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}

- (id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        // Setup world.
        _world = [SKNode node];
        [self addChild:_world];
        
        // Setup physics.
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        
        // Setup player.
        _player = [[Plane alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        _player.engineRunning = YES;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        //self.player.engineRunning = !self.player.engineRunning;
        //[self.player setRandomColour];
        _player.physicsBody.affectedByGravity = YES;
        self.player.accelerating = YES;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        self.player.accelerating = NO;
    }
}


- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self.player update];
}

@end

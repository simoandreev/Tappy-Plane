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

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        // Setup world.
        _world = [SKNode node];
        [self addChild:_world];
        // Setup player.
        _player = [[Plane alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_world addChild:_player];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end

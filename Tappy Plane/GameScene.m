//
//  GameScene.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/15/15.
//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import "GameScene.h"
#import "Plane.h"
#import "ScrollingLayer.h"

@interface GameScene ()

@property (nonatomic) Plane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) ScrollingLayer *background;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation GameScene
 
- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}

- (id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        // Setup world.
        _world = [SKNode node];
        [self addChild:_world];
        
        // Setup physics.
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        
        // Setup background.
        NSMutableArray *backgroudTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            [backgroudTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        _background = [[ScrollingLayer alloc] initWithTiles:backgroudTiles];
        _background.position = CGPointZero;
        _background.horizontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
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


-(void)update:(NSTimeInterval)currentTime
{
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    [self.player update];
    [self.background updateWithTimeElpased:timeElapsed];
}

@end

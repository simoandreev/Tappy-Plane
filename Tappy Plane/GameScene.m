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
#import "Constants.h"

@interface GameScene ()

@property (nonatomic) Plane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) ScrollingLayer *background;
@property (nonatomic) ScrollingLayer *foreground;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation GameScene
 
- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}

- (id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];
        
        // Setup world.
        _world = [SKNode node];
        [self addChild:_world];
        self.physicsWorld.contactDelegate = self;
        
        // Setup physics.
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
        
        // Setup background.
        NSMutableArray *backgroudTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            [backgroudTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        _background = [[ScrollingLayer alloc] initWithTiles:backgroudTiles];
        _background.horizontalScrollSpeed = -60;
        _background.scrolling = YES;
        _background.zPosition = -1;
        [_world addChild:_background];
        
        // Setup player.
        _player = [[Plane alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;

        [_world addChild:_player];
        
        // Setup foreground.
        _foreground = [[ScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                                [self generateGroundTile],
                                                                [self generateGroundTile]]];
        _foreground.horizontalScrollSpeed = -80;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        // Start a new game.
        [self newGame];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (self.player.crashed) {
            //Reset game.
            [self newGame];
        }
        else{
            _player.physicsBody.affectedByGravity = YES;
            self.player.accelerating = YES;
        }
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
    if (!self.player.crashed) {
        [self.background updateWithTimeElpased:timeElapsed];
        [self.foreground updateWithTimeElpased:timeElapsed];
    }
}

-(SKSpriteNode*)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 383 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 373 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 330 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 317 - offsetX, 24 - offsetY);
    CGPathAddLineToPoint(path, NULL, 299 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 283 - offsetX, 9 - offsetY);
    CGPathAddLineToPoint(path, NULL, 268 - offsetX, 8 - offsetY);
    CGPathAddLineToPoint(path, NULL, 254 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 237 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 220 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 185 - offsetX, 29 - offsetY);
    CGPathAddLineToPoint(path, NULL, 173 - offsetX, 22 - offsetY);
    CGPathAddLineToPoint(path, NULL, 155 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 125 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 78 - offsetX, 31 - offsetY);
    CGPathAddLineToPoint(path, NULL, 65 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 43 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 21 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 18 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 18 - offsetY);
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kTPCategoryGround;
    
//    SKShapeNode *bodyShape = [SKShapeNode node];
//    bodyShape.path = path;
//    bodyShape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:1];
//    bodyShape.lineWidth = 2.0;
//    [sprite addChild:bodyShape];
    
    return sprite;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kTPCategoryPlane) {
        [self.player collide:contact.bodyA];
    }
}

-(void)newGame
{
    // Reset layers.
    self.foreground.position = CGPointZero;
    [self.foreground layoutTiles];
    self.background.position = CGPointMake(0, 30);
    [self.background layoutTiles];
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
}


@end

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
#import "ObstacleLayer.h"
#import "BitmapFontLabel.h"
#import "TilesetTextureProvider.h"
#import "ButtonMenuPlay.h"
#import "GetReadyMenu.h"
#import "WeatherLayer.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface GameScene ()

@property (nonatomic) Plane *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) ScrollingLayer *background;
@property (nonatomic) ScrollingLayer *foreground;
@property (nonatomic) ObstacleLayer *obstacles;
@property (nonatomic) BitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) GameOverMenu *gameOverMenu;
@property (nonatomic) GameState gameState;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) GetReadyMenu *getReadyMenu;
@property (nonatomic) WeatherLayer *weather;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;
static NSString *const kTPKeyBestScore = @"BestScore";

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
        _player.physicsBody.affectedByGravity = NO;
        [_world addChild:_player];
        
        // Setup weather.
        //_weather = [[WeatherLayer alloc] initWithSize:self.size];
        //[_world addChild:_weather];
        
        // Setup foreground.
        _foreground = [[ScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                                [self generateGroundTile],
                                                                [self generateGroundTile]]];
        _foreground.horizontalScrollSpeed = -80;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        // Setup obstacle layer.
        _obstacles = [[ObstacleLayer alloc] init];
        _obstacles.zPosition = -1;
        _obstacles.collectableDelegate = self;
        _obstacles.horizontalScrollSpeed = -80;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        // Setup score label.
        _scoreLabel = [[BitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
        [self addChild:_scoreLabel];
        
        // Load best score.
        self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kTPKeyBestScore];
        
//        // Setup test button.
//        ButtonMenuPlay *button = [ButtonMenuPlay spriteNodeWithTexture:[graphics textureNamed:@"buttonPlay"]];
//        [button setPressedTarget:self withAction:@selector(pressedPlayButton)];
//        button.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
//        [self addChild:button];
        
        // Setup game over menu.
        _gameOverMenu = [[GameOverMenu alloc] initWithSize:size];
        _gameOverMenu.delegate = self;
        
        // Setup get ready menu.
        _getReadyMenu = [[GetReadyMenu alloc] initWithSize:size andPlanePosition:CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
        [self addChild:_getReadyMenu];
        
        // Start a new game.
        [self newGame];
    }
    
    return self;
}

//-(void)pressedPlayButton
//{
//    NSLog(@"Pressed the play button");
//}

-(void)wasCollected:(NSInteger )point
{
    self.score += point;
}

-(void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameReady) {
        [self.getReadyMenu hide];
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    if (self.gameState == GameRunning) {
        self.player.accelerating = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameRunning) {
        self.player.accelerating = NO;
    }
}

-(void)bump
{
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(-5, -4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    [self.world runAction:bump];
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
    if (self.gameState == GameRunning && self.player.crashed) {
        // Player just crashed in last frame so trigger game over.
        [self bump];
        [self gameOver];
    }
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElpased:timeElapsed];
        [self.foreground updateWithTimeElpased:timeElapsed];
        [self.obstacles updateWithTimeElpased:timeElapsed];
    }
}

-(MedalType)getMedalForCurrentScore
{
    NSInteger adjustedScore = self.score;
    if (adjustedScore >= 45) {
        return MedalGold;
    } else if (adjustedScore >= 25) {
        return MedalSilver;
    } else if (adjustedScore >= 10) {
        return MedalBronze;
    }
    return MedalNone;
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
    // Randomize tileset.
    [[TilesetTextureProvider getProvider] randomizeTileset];
    
    // Set weather conditions.
    NSString *tilesetName = [TilesetTextureProvider getProvider].currentTilesetName;
    //NSLog(@"TilseSet Name is :%@", tilesetName);
    self.weather.conditions = WeatherClear;
    _weather = [[WeatherLayer alloc] initWithSize:self.size];
    [_world addChild:_weather];
    
    if ([tilesetName isEqualToString:kTPTilesetIce] || [tilesetName isEqualToString:kTPTilesetSnow]) {
        // 1 in 2 chance for snow on snow and ice tilesets.
        if (arc4random_uniform(2) == 0) {
            self.weather.conditions = WeatherSnowing;
        }
    }
    if ([tilesetName isEqualToString:kTPTilesetGrass] || [tilesetName isEqualToString:kTPTilesetDirt]) {
        // 1 in 3 chance for rain on dirt and grass tilesets.
        if (arc4random_uniform(3) == 0) {
            self.weather.conditions = WeatherRaining;
        }
    }
    
    // Reset layers.
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[TilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    // Reset score.
    self.score = 0;
    self.scoreLabel.alpha = 1.0;
    
    // Set game state to ready
    self.gameState = GameReady;
}

-(void)gameOver
{
    // Update game state.
    self.gameState = GameOver;
    // Fade out score display.
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    // Set properties on game over menu
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
    // Updtate best score.
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kTPKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
    // Show game over menu.
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
}

-(void)pressedStartNewGameButton
{
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    
    blackRectangle.anchorPoint = CGPointZero;
    blackRectangle.alpha = 0.0;
    [self addChild:blackRectangle];
    SKAction *startNewGame = [SKAction runBlock:^{
        [self.weather removeFromParent];
        [self newGame];
        [self.gameOverMenu removeFromParent];
        [self.getReadyMenu show];
    }];
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],
                                                    startNewGame,
                                                    [SKAction fadeOutWithDuration:0.6],
                                                    [SKAction removeFromParent]]];
    [blackRectangle runAction:fadeTransition];
}

@end

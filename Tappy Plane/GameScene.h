//
//  GameScene.h
//  Tappy Plane
//

//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collectable.h"
#import "GameOverMenu.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate, CollectableDelegate, GameOverMenuDelegate>

@end

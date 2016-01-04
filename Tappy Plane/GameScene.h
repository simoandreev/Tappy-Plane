//
//  GameScene.h
//  Tappy Plane
//

//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Collectable.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate, CollectableDelegate>

@end

//
//  TileNode.h
//  Scroll Background
//
//  Created by Simeon Andreev on 12/22/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TileNode : SKSpriteNode

@property (nonatomic) TileNode *nextTile;
@property (nonatomic) TileNode *prevTile;

@end

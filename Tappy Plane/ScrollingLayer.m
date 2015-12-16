//
//  ScrollingLayer.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/16/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "ScrollingLayer.h"

@interface ScrollingLayer()

@property (nonatomic) SKSpriteNode *rightmostTile;

@end

@implementation ScrollingLayer

-(id)initWithTiles:(NSArray *)tileSpriteNodes
{
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        [self layoutTiles];
    }
    return self;
}
//We setup a method stub to layout our tiles:
-(void)layoutTiles
{
    self.rightmostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        self.rightmostTile = (SKSpriteNode*)node;
    }];
}

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed {
    [super updateWithTimeElpased:timeElapsed];
    
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
            CGPoint nodePostionInScene = [self convertPoint:node.position toNode:self.scene];
            if (nodePostionInScene.x + node.frame.size.width <
                -self.scene.size.width * self.scene.anchorPoint.x) {
                node.position = CGPointMake(self.rightmostTile.position.x +
                                            self.rightmostTile.size.width, node.position.y);
                self.rightmostTile = (SKSpriteNode*)node;
            }
        }];
    }
}

@end

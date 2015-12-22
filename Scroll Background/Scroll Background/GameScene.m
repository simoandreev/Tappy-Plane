//
//  GameScene.m
//  Scroll Background
//
//  Created by Simeon Andreev on 12/22/15.
//  Copyright (c) 2015 Simeon Andreev. All rights reserved.
//

#import "GameScene.h"
#import "TileNode.h"

static const CGFloat kScrollSpeed = 70.0;

@implementation GameScene {
    TileNode *_leftmostTile;
    TileNode *_rightmostTile;
    int _direction;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.backgroundColor = [SKColor colorWithRed:0.0 green:0.6 blue:1.0 alpha:1.0];
    
    _leftmostTile = nil;
    _rightmostTile = nil;
    for (int i = 0; i < 3; i++) {
        TileNode *tile = [TileNode spriteNodeWithImageNamed:@"desert_BG"];
        tile.anchorPoint = CGPointZero;
        if (!_leftmostTile) {
            _leftmostTile = tile;
        }
        if (_rightmostTile) {
            tile.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _rightmostTile.position.y);
        } else {
            tile.position = CGPointZero;
        }
        tile.prevTile = _rightmostTile;
        _rightmostTile.nextTile = tile;
        _rightmostTile = tile;
        [self addChild:tile];
    }
    _direction = -1;
    _leftmostTile.prevTile = _rightmostTile;
    _rightmostTile.nextTile = _leftmostTile;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    _direction *= -1;
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
       
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    static CFTimeInterval lastCallTime;
    CFTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > 10.0 / 60.0) {
        timeElapsed = 10.0 / 60.0;
    }
    lastCallTime = currentTime;
    CGFloat scrollDistance = kScrollSpeed * timeElapsed;
    TileNode *tile = _leftmostTile;
    do {
        tile.position = CGPointMake(tile.position.x + (scrollDistance * _direction), tile.position.y);
        tile = tile.nextTile;
    } while (tile != _leftmostTile);
    
    if (_direction == -1) {
        if (_leftmostTile.position.x + _leftmostTile.size.width < 0) {
            _leftmostTile.position = CGPointMake(_rightmostTile.position.x + _rightmostTile.size.width, _leftmostTile.position.y);
            _rightmostTile = _leftmostTile;
            _leftmostTile = _leftmostTile.nextTile;
        }
    } else {
        if (_rightmostTile.position.x > self.size.width) {
            _rightmostTile.position = CGPointMake(_leftmostTile.position.x - _rightmostTile.size.width, _rightmostTile.position.y);
            _leftmostTile = _rightmostTile;
            _rightmostTile = _rightmostTile.prevTile;
        }
    }
}


@end

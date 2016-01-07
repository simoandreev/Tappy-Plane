//
//  GetReadyMenu.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/7/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import "GetReadyMenu.h"

@interface GetReadyMenu()

@property (nonatomic) SKSpriteNode *getReadyTitle;
@property (nonatomic) SKNode *tapGroup;

@end

@implementation GetReadyMenu

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition
{
    if (self = [super init]) {
        _size = size;
        
        //Get graphics atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        //Setup ger ready text
        _getReadyTitle = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"textGetReady"]];
        _getReadyTitle.position = CGPointMake(size.width * 0.75, planePosition.y);
        [self addChild:_getReadyTitle];
        
        // Setup group for tap related nodes.
        _tapGroup = [SKNode node];
        _tapGroup.position = planePosition;
        [self addChild:_tapGroup];
        
        // Setup right tap tag.
        SKSpriteNode *rightTapTag = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tapLeft"]];
        rightTapTag.position = CGPointMake(55, 0);
        [self.tapGroup addChild:rightTapTag];
        // Setup left tap tag.
        SKSpriteNode *leftTapTag = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tapRight"]];
        leftTapTag.position = CGPointMake(-55, 0);
        [self.tapGroup addChild:leftTapTag];
        
        // Get frames for tap animation.
        NSArray *tapAnimationFrames = @[[atlas textureNamed:@"tap"],
                                        [atlas textureNamed:@"tapTick"],
                                        [atlas textureNamed:@"tapTick"]];
        // Create action for tap animation.
        SKAction *tapAnimation = [SKAction animateWithTextures:tapAnimationFrames timePerFrame:0.5 resize:YES restore:NO];
        // Setup tap hand.
        SKSpriteNode *tapHand = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"tap"]];
        tapHand.position = CGPointMake(0, -40);
        [self.tapGroup addChild:tapHand];
        [tapHand runAction:[SKAction repeatActionForever:tapAnimation]];

    }
    return self;
}

-(void)show
{
    // Reset nodes.
    self.tapGroup.alpha = 1.0;
    self.getReadyTitle.position = CGPointMake(self.size.width * 0.75, self.getReadyTitle.position.y);
}

-(void)hide
{
    // Create action to fade out tap group.
    SKAction *fadeTapGroup = [SKAction fadeOutWithDuration:0.5];
    [self.tapGroup runAction:fadeTapGroup];
    // Create actions to slide get ready text.
    SKAction *slideLeft = [SKAction moveByX:-30 y:0 duration:0.2];
    slideLeft.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *slideRight = [SKAction moveToX:self.size.width + (self.getReadyTitle.size.width * 0.5) duration:0.6];
    slideRight.timingMode = SKActionTimingEaseIn;
    // Slide get ready text off to the right.
    [self.getReadyTitle runAction:[SKAction sequence:@[slideLeft, slideRight]]];
}

@end

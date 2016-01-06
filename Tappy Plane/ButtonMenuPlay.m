//
//  ButtonMenu.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/6/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import "ButtonMenuplay.h"
#import <objc/message.h>

@interface ButtonMenuPlay()

@property (nonatomic) CGRect fullSizeFrame;

@end

@implementation ButtonMenuPlay

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    ButtonMenuPlay *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            [self setScale:self.pressedScale];
        } else {
            [self setScale:1.0];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button.
            ((void(*)(id, SEL))objc_msgSend)(self.pressedTarget, self.pressedAction);
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}

@end

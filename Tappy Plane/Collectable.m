//
//  Collectable.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/28/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "Collectable.h"

@implementation Collectable

-(void)collect
{
    [self runAction:[SKAction removeFromParent]];
    if (self.delegate) {
        [self.delegate wasCollected];
    }
}

@end

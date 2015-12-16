//
//  ScrollingNode.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/16/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "ScrollingNode.h"

@implementation ScrollingNode

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed {
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
}

@end

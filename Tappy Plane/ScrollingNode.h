//
//  ScrollingNode.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/16/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScrollingNode : SKNode

@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance to scroll per second.
@property (nonatomic) BOOL scrolling;

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed;

@end

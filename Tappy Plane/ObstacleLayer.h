//
//  ObstacleLayer.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/23/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "ScrollingNode.h"

@interface ObstacleLayer : ScrollingNode

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end

//
//  Collectable.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/28/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol CollectableDelegate <NSObject>

-(void)wasCollected;

@end

@interface Collectable : SKSpriteNode

@property (nonatomic, weak) id<CollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

-(void)collect;

@end

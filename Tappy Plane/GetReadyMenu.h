//
//  GetReadyMenu.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/7/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GetReadyMenu : SKNode

@property (nonatomic) CGSize size;

-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;
-(void)show;
-(void)hide;

@end

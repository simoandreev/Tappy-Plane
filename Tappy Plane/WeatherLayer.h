//
//  WeatherLayer.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/7/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    WeatherClear,
    WeatherRaining,
    WeatherSnowing,
} WeatherType;

@interface WeatherLayer : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) WeatherType conditions;

-(instancetype)initWithSize:(CGSize)size;

@end

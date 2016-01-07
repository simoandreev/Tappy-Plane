//
//  WeatherLayer.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/7/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import "WeatherLayer.h"
#import "SoundManager.h"

@interface WeatherLayer()

@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;
@property (nonatomic) Sound *rainSound;

@end

@implementation WeatherLayer

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _size = size;
        // Load rain effect.
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height + 5);
        _rainEmitter.name = @"RainEmitter";
        _rainEmitter.targetNode = self.scene;
        
        // Setup rain sound.
        _rainSound = [Sound soundNamed:@"Rain.caf"];
        _rainSound.looping = YES;
        
        // Load snow effect.
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5);
        _snowEmitter.name = @"SnowEmitter";
        _snowEmitter.targetNode = self.scene;
    }
    return self;
}

-(void)setConditions:(WeatherType)conditions
{
    if (_conditions != conditions) {
        _conditions = conditions;
        // Remove existing weather effect.
        [self removeAllChildren];
        
        // Stop any existing sounds from playing.
        if (self.rainSound.playing) {
            [self.rainSound fadeOut:1.0];
        }
        // Add weather conditions.
        switch (conditions) {
            case WeatherRaining:
                [self.rainSound play];
                [self.rainSound fadeIn:1.0];
                [self addChild:self.rainEmitter];
                [self.rainEmitter advanceSimulationTime:5];
                break;
            case WeatherSnowing:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];
                break;
            default:
                [self removeAllChildren];
                break;
        }
    }
}

@end

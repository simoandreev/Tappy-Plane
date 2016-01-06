//
//  GameOverMenu.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/6/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;

@protocol GameOverMenuDelegate <NSObject>

-(void)pressedStartNewGameButton;

@end

@interface GameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id<GameOverMenuDelegate> delegate;

-(instancetype)initWithSize:(CGSize)size;
-(void)show;

@end

//
//  TilesetTextureProvider.h
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/5/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TilesetTextureProvider : NSObject

@property (nonatomic) NSString *currentTilesetName;

+(instancetype)getProvider;

-(void)randomizeTileset;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end

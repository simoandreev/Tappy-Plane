//
//  TilesetTextureProvider.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 1/5/16.
//  Copyright © 2016 Simeon Andreev. All rights reserved.
//

#import "TilesetTextureProvider.h"

@interface TilesetTextureProvider ()

@property (nonatomic) NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation TilesetTextureProvider


+(instancetype)getProvider
{
    static TilesetTextureProvider* provider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provider = [[self alloc] init];
    });
    
    return provider;
}

/*
 +(instancetype)getProvider
 {
 static TPTilesetTextureProvider* provider = nil;
 @synchronized(self) {
 if (!provider) {
 provider = [[TPTilesetTextureProvider alloc] init];
 }
 return provider;
 }
 }
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTilesets];
        [self randomizeTileset];
    }
    return self;
}

-(void)loadTilesets
{
    self.tilesets = [[NSMutableDictionary alloc] init];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    // Get path to property list.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TilesetGraphics" ofType:@"plist"];
    // Load contents of file.
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // Loop through tilesetList.
    for (NSString *tilesetKey in tilesetList) {
        // Get dictionary of texture names.
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        // Create dictionary to hold textures.
        NSMutableDictionary *textures = [[NSMutableDictionary alloc] init];
        for (NSString *textureKey in textureList) {
            // Get texture for key.
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            // Insert texture to textures dictionary.
            [textures setObject:texture forKey:textureKey];
        }
        
        // Add textures dictionary to tilesets.
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
}

-(void)randomizeTileset
{
    NSArray *tilesetKeys = [self.tilesets allKeys];
    // NSLog(@"tilesetKeys %@", tilesetKeys);
    NSString *key = [tilesetKeys objectAtIndex:arc4random_uniform((uint)tilesetKeys.count)];
   // NSLog(@"Key %@", key);
    self.currentTileset = [self.tilesets objectForKey:key];
   // NSLog(@"TileSet %@", self.currentTileset);
}

-(SKTexture*)getTextureForKey:(NSString *)key
{
    return [self.currentTileset objectForKey:key];
}

@end

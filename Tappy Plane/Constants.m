//
//  Constants.m
//  Tappy Plane
//
//  Created by Simeon Andreev on 12/23/15.
//  Copyright © 2015 Simeon Andreev. All rights reserved.
//

#import "Constants.h"

@implementation Constants

const uint32_t kTPCategoryPlane = 0x1 << 0;
const uint32_t kTPCategoryGround = 0x1 << 1;
const uint32_t kTPCategoryCollectable = 0x1 << 2;
NSString *const kTPKeyMountainUp = @"mountainUp";
NSString *const kTPKeyMountainDown = @"mountainDown";
NSString *const kTPKeyMountainUpAlternate = @"mountainUpAlternate";
NSString *const kTPKeyMountainDownAlternate = @"mountainDownAlternate";
NSString *const kTPKeyCollectableStar = @"CollectableStar";

@end

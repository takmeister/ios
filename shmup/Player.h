//
//  Player.h
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

@property (nonatomic) float primaryfirerate;
@property (nonatomic) float thespeed;

-(Player*)init:(CGPoint)pos withSize:(CGSize)initsize  withHitmarkersize:(CGSize)markersize withSpeed:(float)initspeed withTexture:(int)ID withType:(int)thetype;

@end

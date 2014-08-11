//
//  Bullet.h
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/21.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKSpriteNode

@property (nonatomic)float decay;
@property (nonatomic)bool isEnemy;
@property (nonatomic)float power;

-(Bullet*)init:(float)radius andPosition:(CGPoint)pos withSpeed:(CGVector)speed isEnemy:(bool)isEnemy andDecay:(float)decayinit;

@end

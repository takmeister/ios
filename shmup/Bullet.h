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

-(Bullet*)init:(float)radius andPosition:(CGPoint)pos withSpeed:(CGVector)speed andDecay:(float)decayinit;

@end

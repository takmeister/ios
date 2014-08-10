//
//  Bullet.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/21.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

static const uint32_t playerbullet = 0x1 << 1;

-(Bullet*)init:(float)radius andPosition:(CGPoint)pos withSpeed:(CGVector)speed andDecay:(float)decayinit{
    self = [super initWithColor:[UIColor greenColor] size:CGSizeMake(radius, radius)];
    self.position = pos;
    self.zPosition = 2;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.allowsRotation = false;
    self.physicsBody.velocity = speed;
    self.physicsBody.linearDamping = 0;
    self.decay = decayinit;
    
    self.physicsBody.categoryBitMask = playerbullet;
    self.physicsBody.collisionBitMask = 0;
    
    return self;
}

@end

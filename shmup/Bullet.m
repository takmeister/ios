//
//  Bullet.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/21.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Bullet.h"
#import "MyScene.h"

@implementation Bullet

-(Bullet*)init:(float)radius andPosition:(CGPoint)pos withSpeed:(CGVector)speed isEnemy:(bool)isEnemy andDecay:(float)decayinit{
    self = [super initWithColor:[UIColor greenColor] size:CGSizeMake(radius, radius)];
    self.position = pos;
    self.zPosition = 2;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.velocity = speed;
    self.physicsBody.linearDamping = 0;
    self.decay = decayinit;
    self.physicsBody.allowsRotation = false;
    self.isEnemy = isEnemy;
    self.power = radius * sqrtf(pow(speed.dx, 2) + pow(speed.dy, 2)) / 100;
    self.physicsBody.categoryBitMask = 0;
    self.physicsBody.contactTestBitMask = playerCategory | enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.affectedByGravity = false;
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:self.decay],[SKAction runBlock:^{[self removeFromParent];}]]]];
    
    return self;
}

@end

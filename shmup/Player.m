//
//  Player.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Player.h"
#import "Bullet.h"
#import "MyScene.h"

@implementation Player

-(Player*)init:(CGPoint)pos withSize:(CGSize)initsize withHitmarkersize:(CGSize)markersize withSpeed:(float)initspeed withTexture:(int)ID withType:(int)thetype{
    if (thetype == 0) {
        //Player
        self = [super initWithTexture:[SKTexture textureWithImageNamed:@"robot0.png"]];
        self.position = pos;
        self.health = 100;
    }
    self.size = initsize;
    self.thespeed = initspeed;
    self.zPosition = 2;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:markersize];
    self.physicsBody.allowsRotation =  FALSE;
    self.primaryfirerate = 10;
    self.physicsBody.categoryBitMask = playerCategory;
    self.physicsBody.contactTestBitMask = bulletCategory;
    self.physicsBody.dynamic = false;
    return self;
}

-(void)damage:(int)power {
    self.health -= power;
    
    if (self.health <= 0) {
        [self removeFromParent];
    }
}

@end

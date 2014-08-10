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
    }
    self.size = initsize;
    self.thespeed = initspeed;
    self.zPosition = 2;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:markersize];
    self.physicsBody.allowsRotation =  FALSE;
    self.primaryfirerate = 10;
    self.physicsBody.dynamic = false;
    self.physicsBody.categoryBitMask = player;
    return self;
}

@end

//
//  Enemy.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/08/10.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "MyScene.h"
#import "Enemy.h"
#import "Bullet.h"

@implementation Enemy

-(Enemy*)init:(int)ID {
    if (ID == 0) {
        //Test Enemy
        self = [super initWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        self.position = CGPointMake(screensize.width, screensize.height / 2);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.dynamic = FALSE;
        self.physicsBody.categoryBitMask = enemyCategory;
        self.physicsBody.contactTestBitMask = bulletCategory;
        [self runAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(-screensize.width * 2, 0) duration:20],[SKAction runBlock:^{[self removeFromParent];}]]]];
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction runBlock:^{
            Bullet *enemybullet = [[Bullet alloc]init:10 andPosition:self.position withSpeed:CGVectorMake(-100, 0) isEnemy:true andDecay:5];
            [self.scene addChild:enemybullet];
        }]]]];
    }
    
    return self;
}
@end

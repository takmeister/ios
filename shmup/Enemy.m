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
        self.position = CGPointMake(screensize.width, arc4random() % (int)screensize.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        self.physicsBody.allowsRotation = FALSE;
        self.physicsBody.dynamic = FALSE;
        self.physicsBody.categoryBitMask = enemyCategory;
        self.physicsBody.contactTestBitMask = bulletCategory;
        [self runAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(-screensize.width * 2, 0) duration:20],[SKAction runBlock:^{[self removeFromParent];}]]]];
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction runBlock:^{
            Bullet *enemybullet = [[Bullet alloc]init:10 andPosition:self.position withSpeed:CGVectorMake(-150, 0) isEnemy:true andDecay:5];
            [self.scene addChild:enemybullet];
        }]]]];
        self.health = 1000;
        
        randomTime = arc4random() % 5;
    }
    
    return self;
}

-(void)damage:(int)power {
    self.health -= power;
    
    SKLabelNode *damage = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
    damage.text = [NSString stringWithFormat:@"%d",power];
    damage.position = self.position;
    damage.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
    damage.physicsBody.collisionBitMask = 0;
    damage.physicsBody.velocity = CGVectorMake(80, 80);
    [self.scene addChild:damage];
    damage.zPosition = 5;
    [damage runAction:[SKAction sequence:@[[SKAction waitForDuration:5],[SKAction runBlock:^{[damage removeFromParent];}]]]];
    
    //Damage animation
    SKAction *jitter1 = [SKAction moveBy:CGVectorMake(5, 5) duration:0.03];
    SKAction *jitter2 = [SKAction moveBy:CGVectorMake(-5, -5) duration:0.03];
    
    SKAction *damagesequence = [SKAction sequence:@[jitter1,jitter2]];
    
    [self runAction:[SKAction repeatAction:damagesequence count:3]];
    
    if (self.health <= 0) {
        [self removeFromParent];
    }
}
@end

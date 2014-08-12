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
    
    SKLabelNode *damage = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
    damage.text = [NSString stringWithFormat:@"%d",power];
    damage.position = self.position;
    damage.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
    damage.physicsBody.collisionBitMask = 0;
    damage.physicsBody.velocity = CGVectorMake(-80, 80);
    damage.zPosition = 5;
    [self.scene addChild:damage];
    [damage runAction:[SKAction sequence:@[[SKAction waitForDuration:5],[SKAction runBlock:^{[damage removeFromParent];}]]]];
    
    //Damage animation
    SKAction *jitter1 = [SKAction moveBy:CGVectorMake(5, 5) duration:0.03];
    SKAction *jitter2 = [SKAction moveBy:CGVectorMake(-5, -5) duration:0.03];
    
    SKAction *damagesequence = [SKAction sequence:@[jitter1,jitter2]];
    
    [self runAction:[SKAction repeatAction:damagesequence count:3]];
    
    if (self.health <= 0) { //Death
        
        SKAction *deathAnimation = [SKAction rotateByAngle:30*M_PI duration:3];
        isAlive = false;
        self.physicsBody.dynamic = true;
        self.physicsBody.allowsRotation = true;
        self.physicsBody.velocity = CGVectorMake(-80, 80);
        [self removeAllChildren];
        
        [self runAction:[SKAction sequence:@[deathAnimation,[SKAction runBlock:^{[self removeFromParent];}]]]];
    }
}

@end

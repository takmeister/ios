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
        [self runAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(-screensize.width * 2, 0) duration:10],[SKAction runBlock:^{[self removeFromParent];}]]]];
        
        SKAction *behaviour = [SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction runBlock:^{
            Bullet *enemybullet = [[Bullet alloc]init:CGSizeMake(10, 10) andPosition:self.position withSpeed:CGVectorMake(-(250 + 20*(score/5000)), 0) isEnemy:true andDecay:5];
            [self.scene addChild:enemybullet];
        }]]];
        
        [self runAction:[SKAction repeatAction:behaviour count:3]];
        self.maxhealth = 500;
    }
    
    if (ID == 1) {
        //Sine Enemy
        self = [super initWithColor:[UIColor blueColor] size:CGSizeMake(50, 50)];
        self.position = CGPointMake(screensize.width, arc4random() % (int)screensize.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        
        CGMutablePathRef sinePath = CGPathCreateMutable();
        CGPathMoveToPoint(sinePath, NULL, screensize.width, arc4random() % (int)screensize.height);
        
        float cp1x, cp1y, cp2x;
        
        cp1x = screensize.width * 0.75;
        cp2x = screensize.width * 0.50;
        cp1y = arc4random() % (int)screensize.height;
        
        CGPathAddCurveToPoint(sinePath, NULL, cp1x, cp1y, cp2x, cp1y, 0, cp1y);
        
        [self runAction:[SKAction sequence:@[[SKAction followPath:sinePath asOffset:NO orientToPath:YES duration:5],[SKAction runBlock:^{[self removeFromParent];}]]] withKey:@"actions"];
        
        //Maths bit
        float opposite = maine.position.y - self.position.y;
        float adjacent = maine.position.x - self.position.x;
        
        float angle = atanf(opposite/adjacent);
        int magnitude = 500;
        
        float cosine = -magnitude*cosf(angle);
        float sine = -magnitude*sinf(angle);
        
        SKAction *shootOne = [SKAction runBlock:^{
            Bullet *enemybullet = [[Bullet alloc]init:CGSizeMake(6, 6) andPosition:self.position withSpeed:CGVectorMake(cosine, sine) isEnemy:true andDecay:5];
            [self.scene addChild:enemybullet];
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[shootOne,[SKAction waitForDuration:0.5]]]]];
        
        self.maxhealth = 1000;
    }
    
    if (ID == 2) {
        //Bullet man
        self = [super initWithColor:[UIColor magentaColor] size:CGSizeMake(20, 20)];
        self.position = CGPointMake(screensize.width, arc4random() % (int)screensize.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        [self runAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(-screensize.width * 2, 0) duration:5],[SKAction runBlock:^{[self removeFromParent];}]]]];
        SKAction *shootBullet = [SKAction sequence:@[[SKAction waitForDuration:0.5],[SKAction runBlock:^{
            Bullet *enemybullet = [[Bullet alloc]init:CGSizeMake(6, 6) andPosition:self.position withSpeed:CGVectorMake(-550, 0) isEnemy:true andDecay:5];
            [self.scene addChild:enemybullet];
        }]]];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[shootBullet,[SKAction waitForDuration:3]]]]];
        
        self.maxhealth = 1000;
        
    }
    if (ID == 3) {
        //Move and Stop guy
        self = [super initWithColor:[UIColor grayColor] size:CGSizeMake(30, 70)];
        self.position = CGPointMake(screensize.width, arc4random() % (int)screensize.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        
        SKAction *moveleft = [SKAction moveBy:CGVectorMake(-screensize.width/4, 0) duration:1];
        SKAction *moveup = [SKAction moveToY:(screensize.height - self.size.height/2 - arc4random() % 200) duration:0.5];
        SKAction *movedown = [SKAction moveToY:(self.size.height/2 + arc4random() % 200) duration:0.5];
        SKAction *disappear = [SKAction runBlock:^{[self removeFromParent];}];
        
        [self runAction:[SKAction sequence:@[moveleft,moveup,moveleft,movedown,moveleft,moveup,moveleft,moveleft,disappear]] withKey:@"actions"];
        
        self.maxhealth = 2000;
    }
    if (ID == 4) {
        //Stop in middle then rape
        self = [super initWithColor:[UIColor yellowColor] size:CGSizeMake(30, 30)];
        self.position = CGPointMake(screensize.width, arc4random() % (int)screensize.height);
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
        
        SKAction *movecenter = [SKAction moveTo:CGPointMake(screensize.width / 2, screensize.height / 2) duration:1];
        SKAction *shrink = [SKAction scaleTo:0 duration:1];
        SKAction *disappear = [SKAction runBlock:^{[self removeFromParent];}];
        
        [self runAction:[SKAction sequence:@[movecenter,shrink,disappear]] withKey:@"actions"];
        
        self.maxhealth = 2000;
    }
    
    
    //Enemy hitbox such that when player hits the enemy, imminent death
    Bullet *hitmarker = [[Bullet alloc]init:self.size andPosition:CGPointMake(0, 0) withSpeed:CGVectorMake(0, 0) isEnemy:YES andDecay:30];
    hitmarker.hidden = YES;
    [self addChild:hitmarker];
    self.health = self.maxhealth;
    self.physicsBody.allowsRotation = FALSE;
    self.physicsBody.dynamic = FALSE;
    self.physicsBody.categoryBitMask = enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    
    cooling = true;
    
    float randomiser = arc4random() % 3;
    
    SKAction *wait = [SKAction waitForDuration:randomiser];
    SKAction *uncooldown = [SKAction runBlock:^{cooling = false;}];
    
    [self runAction:[SKAction sequence:@[wait,uncooldown]]];
    
    return self;
}

-(void)damage:(int)power { //When Enemy is Damaged
    self.health -= power;
    
    if (power == 0) {
        self.health = 0;
    }
    
    SKLabelNode *damage = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
    damage.text = [NSString stringWithFormat:@"%d",power];
    damage.position = self.position;
    damage.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
    damage.physicsBody.collisionBitMask = 0;
    damage.physicsBody.velocity = CGVectorMake(80, 80);
    [self.scene addChild:damage];
    damage.zPosition = 5;
    [damage runAction:[SKAction sequence:@[[SKAction waitForDuration:5],[SKAction runBlock:^{[damage removeFromParent];}]]]];
    
    NSString *sparks =
    [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
    
    SKEmitterNode *sparkDamage = [NSKeyedUnarchiver unarchiveObjectWithFile:sparks];
    [self addChild:sparkDamage];
    [sparkDamage runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],[SKAction runBlock:^{[sparkDamage removeFromParent];}]]]];
    
    //Damage animation
    SKAction *jitter1 = [SKAction moveBy:CGVectorMake(5, 5) duration:0.03];
    SKAction *jitter2 = [SKAction moveBy:CGVectorMake(-5, -5) duration:0.03];
    
    SKAction *damagesequence = [SKAction sequence:@[jitter1,jitter2]];
    [self runAction:[SKAction repeatAction:damagesequence count:3]];
        
        if (self.health <= 0) { //Death Sequence
            score += self.maxhealth;
            
            SKAction *deathAnimation = [SKAction rotateByAngle:-10*M_PI duration:3];
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1, 1)];
            self.physicsBody.categoryBitMask = 0;
            self.physicsBody.collisionBitMask = 0;
            self.physicsBody.contactTestBitMask = 0;
            self.physicsBody.dynamic = true;
            self.physicsBody.allowsRotation = true;
            self.physicsBody.velocity = CGVectorMake(80, 80);
            [self removeActionForKey:@"actions"];
            [self removeAllChildren];
            
            [self runAction:[SKAction sequence:@[deathAnimation,[SKAction runBlock:^{[self removeFromParent];}]]]];
        }
}
@end

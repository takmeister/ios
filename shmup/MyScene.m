//
//  MyScene.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "Player.h"
#import "Movearea.h"
#import "Bullet.h"
#import "Enemy.h"

Player *maine;
Movearea *leftarea;
Movearea *rightarea;
CGPoint offset;
SKAction *bulletspawn;

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        screensize = self.size;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, -5);
        self.physicsWorld.contactDelegate = self;
        
        //Player
        maine = [[Player alloc]init:CGPointMake(100, 100) withSize:CGSizeMake(40, 70) withHitmarkersize:CGSizeMake(5, 5) withSpeed:2.0 withTexture:0 withType:0];
        [self addChild:maine];
        
        isAlive = true;
        
        //Objects
        SKAction *spawn = [SKAction runBlock:^{
            Enemy *newinit = [[Enemy alloc] init:0];
            [self addChild:newinit];
        }];
        
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[spawn,[SKAction waitForDuration:2]]]]];
        
        //Touch Interface
        leftarea = [[Movearea alloc]initWithColor:[UIColor yellowColor] andSize:CGSizeMake(screensize.width / 2, screensize.height) andID:0 andPosition:CGPointMake(screensize.width / 4, screensize.height / 2)];
        [self addChild:leftarea];
        rightarea = [[Movearea alloc]initWithColor:[UIColor cyanColor] andSize:CGSizeMake(screensize.width / 2, screensize.height) andID:1 andPosition:CGPointMake(screensize.width * 0.75, screensize.height / 2)];
        [self addChild:rightarea];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    return self;
}

-(void)shootbullets:(Player*)thechosen{
    bulletspawn = [SKAction runBlock:^{
        Bullet *newbullet = [[Bullet alloc]init:10 andPosition:CGPointMake(maine.position.x, maine.position.y) withSpeed:CGVectorMake(1500, 0) isEnemy:false andDecay:5];
        [self addChild:newbullet];
        
        SKAction *remove = [SKAction removeFromParent];
        SKAction *wait = [SKAction waitForDuration:newbullet.decay];
        
        [newbullet runAction:[SKAction sequence:@[wait,remove]]];
    }];
    SKAction *recharge = [SKAction waitForDuration:0.1];
    
    [thechosen runAction:[SKAction repeatActionForever:[SKAction sequence:@[bulletspawn,recharge]]] withKey:@"shooting"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode*)[self nodeAtPoint:location];
    Movearea *picked = (Movearea*)[self nodeAtPoint:location];
    
    if ([touched isKindOfClass:[Movearea class]]) {
        [picked touchBind:touch];
        if (picked.identity == 0){
            offset = maine.position;
        }
        else if (picked.identity == 1){
            [self shootbullets:maine];
        }
    }
    
    else {
        return;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *touched = (SKSpriteNode*)[self nodeAtPoint:location];
    Movearea *picked = (Movearea*)[self nodeAtPoint:location];
    
    if ([touched isKindOfClass:[Movearea class]]){
        [picked touchunbind:touch];
        if (picked.identity == 0){
        offset = maine.position;
        }
        if (picked.identity == 1){
            [maine removeActionForKey:@"shooting"];
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKSpriteNode *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = (SKSpriteNode *)contact.bodyA.node;
        secondBody = (SKSpriteNode *)contact.bodyB.node;
    }
    else {
        firstBody = (SKSpriteNode *)contact.bodyB.node;
        secondBody = (SKSpriteNode *)contact.bodyA.node;
    }
    //Check if the player hit a bullet, so that it is safe to cast them as their respective classes
    if (([firstBody isKindOfClass:[Bullet class]]) && ([secondBody isKindOfClass:[Player class]])){
        Bullet *selectBullet = (Bullet*)firstBody;
        Player *selectPlayer = (Player*)secondBody;
        
        if (selectBullet.isEnemy == true) { //Bullet is from enemy
            [selectBullet removeFromParent];
            [selectPlayer damage:selectBullet.power];
        }
    }
    else if (([firstBody isKindOfClass:[Bullet class]]) && ([secondBody isKindOfClass:[Enemy class]])){
        Bullet *selectBullet = (Bullet*)firstBody;
        Enemy *selectEnemy = (Enemy*)secondBody;
        
        if (selectBullet.isEnemy == false) { //Bullet is from player
            [selectBullet removeFromParent];
            [selectEnemy damage:selectBullet.power];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (isAlive == true){
    [leftarea drag];
    [rightarea drag];
    }
    
    if ((maine.position.x + leftarea.displacement.x * maine.thespeed <= screensize.width)&&(maine.position.x + leftarea.displacement.x * maine.thespeed >= 0)&&(maine.position.y + leftarea.displacement.y * maine.thespeed <= screensize.height)&&(maine.position.y + leftarea.displacement.y * maine.thespeed >= 0)){
        maine.position = CGPointMake(maine.position.x + leftarea.displacement.x * maine.thespeed, maine.position.y + leftarea.displacement.y * maine.thespeed);
    }
}

@end

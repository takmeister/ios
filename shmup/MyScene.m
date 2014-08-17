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
#import "PBParallaxBackground.h" //new
#import "Button.h"
#import "MenuScene.h"

Movearea *leftarea;
Movearea *rightarea;
CGPoint offset;
SKAction *bulletspawn;
SKNode *enemyNodes;
bool deathMenu;
NSString *bodyFont = @"HelveticaNeue-Light";
SKLabelNode *dismiss;

//new

@interface MyScene ()

@property (nonatomic, strong) PBParallaxBackground * parallaxBackground;

@end

//new

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        screensize = self.size;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, -5);
        self.physicsWorld.contactDelegate = self;
        deathMenu = false;
        score = 0;
        enemyNodes = [SKNode node];
        [self addChild:enemyNodes];
        
        NSArray * imageNames = @[@"ponyX.jpeg", @"starsX.jpeg", @"kaga.png"];
        PBParallaxBackground * parallax = [[PBParallaxBackground alloc] initWithBackgrounds:imageNames size:size direction:kPBParallaxBackgroundDirectionLeft fastestSpeed:4
                                                                           andSpeedDecrease:1];
        self.parallaxBackground = parallax;
        [self addChild:parallax];
        
        //Player
        maine = [[Player alloc]init:CGPointMake(100, 100) withSize:CGSizeMake(40, 70) withHitmarkersize:CGSizeMake(15, 15) withSpeed:2.0 withTexture:0 withType:0];
        [self addChild:maine];
        
        isAlive = true; //Player is alive
        cooling = false; //Enemy Spawn Cooldown inactive
        
        //Objects
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:bodyFont];
        scoreLabel.position = CGPointMake(screensize.width / 2, screensize.height - 30);
        scoreLabel.zPosition = 6;
        [self addChild:scoreLabel];
        
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
        Bullet *newbullet = [[Bullet alloc]init:CGSizeMake(10, 10) andPosition:CGPointMake(maine.position.x, maine.position.y) withSpeed:CGVectorMake(1500, 0) isEnemy:false andDecay:5];
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
        else if (picked.identity == 2){
            dismiss.alpha = 0.2;
            
            SKScene *NextScene =
            [[MenuScene alloc]initWithSize:self.size]; //call menu
            
            SKTransition *doors =
            [SKTransition fadeWithColor:[UIColor blackColor] duration:1.0];
            
            [self.view presentScene:NextScene transition:doors];
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
    
    [self.parallaxBackground update:currentTime];
    
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d Health: %d",(int)score,maine.health];
    
    enemyNodes.speed = 1.0 + (score)/50000;
    
    //Enemy Generation Code from random integer 'picker'
    
    if (cooling == false) {
        int picker = arc4random_uniform(100);
        
        Enemy *enemyObject;
        
        if (picker >= 95) {
            enemyObject = [[Enemy alloc]init:4];
        }
        else if (picker >= 80) {
            enemyObject = [[Enemy alloc]init:3];
        }
        else if (picker >= 60) {
            enemyObject = [[Enemy alloc]init:2];
        }
        else if (picker >= 40) {
            enemyObject = [[Enemy alloc]init:1];
        }
        else {
            enemyObject = [[Enemy alloc]init:0];
        }
        [enemyNodes addChild:enemyObject];
    }
    
    if (isAlive == true){
    [leftarea drag];
    [rightarea drag];
    }
    else if ((isAlive == false) && (deathMenu == false)){ //Death Transitions and Menu
        SKShapeNode *exitCanvas = [[SKShapeNode alloc]init];
        
        exitCanvas.path = CGPathCreateWithRoundedRect(CGRectMake(0, 0, screensize.width/2, screensize.height/2), 4, 4, NULL);
        exitCanvas.fillColor = [UIColor whiteColor];
        exitCanvas.lineWidth = 0;
        exitCanvas.position = CGPointMake(screensize.width/4, screensize.height * 1.5);
        exitCanvas.zPosition = 110;
        
        [self addChild:exitCanvas];
        
        dismiss = [SKLabelNode labelNodeWithFontNamed:bodyFont];
        dismiss.text = @"Return to Menu";
        dismiss.fontColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        [exitCanvas addChild:dismiss];
        dismiss.position = CGPointMake(screensize.width/4, screensize.height/4);
        
        Movearea *exitButton = [[Movearea alloc]initWithColor:[UIColor redColor] andSize:CGSizeMake(screensize.width/2, screensize.height/2) andID:2 andPosition:CGPointMake(0, 0)];
        [exitCanvas addChild:exitButton];
        exitButton.position = CGPointMake(screensize.width/4, screensize.height/4);
        
        exitCanvas.alpha = 0.7;
        deathMenu = true;
        
        SKSpriteNode *darkShadow = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:screensize];
        darkShadow.alpha = 0;
        darkShadow.zPosition = 19;
        darkShadow.position = CGPointMake(screensize.width/2, screensize.height/2);
        [self addChild:darkShadow];
        
        [exitCanvas runAction:[SKAction moveTo:CGPointMake(screensize.width/4, screensize.height/4) duration:1]];
        [darkShadow runAction:[SKAction fadeAlphaTo:0.7 duration:1]];
        [scoreLabel runAction:[SKAction moveToY:screensize.height + scoreLabel.fontSize duration:1]];
    }
    
    if ((maine.position.x + leftarea.displacement.x * maine.thespeed <= screensize.width)&&(maine.position.x + leftarea.displacement.x * maine.thespeed >= 0)&&(maine.position.y + leftarea.displacement.y * maine.thespeed <= screensize.height)&&(maine.position.y + leftarea.displacement.y * maine.thespeed >= 0)){
        maine.position = CGPointMake(maine.position.x + leftarea.displacement.x * maine.thespeed, maine.position.y + leftarea.displacement.y * maine.thespeed);
    }
}

@end

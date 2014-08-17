//
//  MenuScene.m
//  Main menu class.
//  LAST EDIT: 12/08/14
//  FUNCTIONAL VER.
//  Created by Evgeniy on 11/08/2014.
//  Copyright (c) 2014 Evgeniy. All rights reserved.
//

#import "MenuScene.h"
#import "Myscene.h"
#import "ExtraScene1.h"

@interface MenuScene ()
@property BOOL sceneCreated;
@end

@implementation MenuScene

- (void) didMoveToView:(SKView *)view
{
    if (!self.sceneCreated)
    {
        self.backgroundColor = [SKColor whiteColor];
        self.scaleMode = SKSceneScaleModeAspectFill;
        [self addChild: [self createWelcomeNode]];
        [self addChild: [self createExtraNode1]];
        //add more children here for more scenes
        self.sceneCreated = YES;
    }
}
//button nodes
- (SKSpriteNode *) createWelcomeNode
{
    SKSpriteNode *welcomeNode = [SKSpriteNode spriteNodeWithImageNamed:@"button.png"];
    
  
    welcomeNode.name = @"welcomeNode";

    welcomeNode.position =
    CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    welcomeNode.zPosition=1.0;
    
    return welcomeNode;
}
//as a practice, future nodes will be 1-2-3
- (SKSpriteNode *) createExtraNode1
{
    SKSpriteNode *extraNode = [SKSpriteNode spriteNodeWithImageNamed:@"kaga.png"];
    
    
    extraNode.name = @"extraNode";
    
    extraNode.position =
    CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMinY(self.frame)+50);
    
    extraNode.zPosition=1.0;
    
    return extraNode;
}

//touch response
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //assign touch to new SKNode object, isolate case to self
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode * node=[self nodeAtPoint:location];
    
    // if welcomeNode is touched, do stuff YEYE
    if ([node.name isEqualToString:@"welcomeNode"])
    {
        //animation
        SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
        [node runAction:fadeAway completion:^
        {
         SKScene *NextScene =
         [[MyScene alloc]initWithSize:self.size]; //call game
        
              SKTransition *doors =
              [SKTransition fadeWithColor:[UIColor blackColor] duration:1.0];
        
             [self.view presentScene:NextScene transition:doors];

        }
        ];
    }
    
    else if ([node.name isEqualToString:@"extraNode"])
    {
        //animation
        SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
        [node runAction:fadeAway completion:^
         {
             SKScene *NextScene =
             [[ExtraScene1 alloc]initWithSize:self.size]; //call other scene
             
             SKTransition *doors =
             [SKTransition doorwayWithDuration:1.0];
             
             [self.view presentScene:NextScene transition:doors];
             
         }
         ];
    }

}
@end

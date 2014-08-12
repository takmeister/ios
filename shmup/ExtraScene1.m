//
//  ExtraScene1.m
//  Class for extra pages such as options, shop etc, this is the basis for all other static scenes.
//  LAST EDIT: 12/08/14
//  FUNCTIONAL VER.
//  Created by Evgeniy on 12/08/2014.
//  Copyright (c) 2014 Evgeniy. All rights reserved.
//

#import "ExtraScene1.h"
#import "MenuScene.h"
#import "ViewController.h"

@interface ExtraScene1()
@property BOOL sceneCreated;
@end

@implementation ExtraScene1

- (void) didMoveToView:(SKView *)view
{
    if (!self.sceneCreated)
    {
        self.backgroundColor = [SKColor whiteColor];
        self.scaleMode = SKSceneScaleModeAspectFill;
        [self addChild: [self createExitNode]];
        //add more children for buttons/functionality
        self.sceneCreated = YES;
    }
}

//home button node
- (SKSpriteNode *) createExitNode
{
    SKSpriteNode *exitNode = [SKSpriteNode spriteNodeWithImageNamed:@"goHome.png"];
    
    
    exitNode.name = @"exitNode";
    
    exitNode.position =
    CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    exitNode.zPosition=1.0;
    
    return exitNode;
}

//touch input
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode * node=[self nodeAtPoint:location];
    
    // if ExitNode is touched, do stuff YEYE
    if ([node.name isEqualToString:@"exitNode"])
    {
        //animation
        SKAction *fadeAway = [SKAction fadeOutWithDuration:1.0];
        [node runAction:fadeAway completion:^
         {
             MenuScene *NextScene = [[MenuScene alloc]initWithSize:self.size];
             
             SKTransition *doors =
             [SKTransition doorwayWithDuration:1.0];
             
             [self.view presentScene:NextScene transition:doors];
             
         }
         ];
    }
}

@end

//
//  MyScene.h
//  shmup
//

//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

static const uint32_t bulletCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;
static const uint32_t enemyCategory = 0x1 << 2;

bool isAlive;
bool cooling;

double score;

CGSize screensize;
Player *maine;
SKLabelNode *scoreLabel;



@interface MyScene : SKScene <SKPhysicsContactDelegate>

@end

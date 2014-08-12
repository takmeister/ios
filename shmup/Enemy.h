//
//  Enemy.h
//  shmup
//
//  Created by Yuya Takeuchi on 2014/08/10.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode

@property (nonatomic) int health;
@property (nonatomic) int maxhealth;

-(Enemy*)init:(int)ID;

-(void)damage:(int)power;

@end

//
//  Hitmarker.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/21.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Hitmarker.h"

@implementation Hitmarker

-(Hitmarker*)init:(CGSize)sizeinit andPosition:(CGPoint)posinit{
    self = [super initWithColor:[UIColor redColor] size:sizeinit];
    self.position = posinit;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sizeinit];
    return self;
}

@end

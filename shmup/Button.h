//
//  Button.h
//  shmup
//
//  Created by Yuya Takeuchi on 2014/08/16.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Button : SKSpriteNode

-(Button*)init:(CGSize)initSize withPosition:(CGPoint)initPos andName:(NSString*)initName;

@end

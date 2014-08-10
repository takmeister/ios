//
//  Movearea.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Movearea.h"

@implementation Movearea

-(SKSpriteNode*) initWithColor:(UIColor*)color andSize:(CGSize)size andID:(NSUInteger)id andPosition:(CGPoint)position{
    self = [super initWithColor:color size:size];
    self.position = position;
    self.alpha = 0.0f;
    self.identity = id;
    self.zPosition = 100;
    
    return self;
}

-(BOOL)isdragged{
    return (self.touch != nil);
}

-(void)touchBind:(UITouch*) touch {
    self.touch = touch;
    
    CGPoint location = [self.touch locationInNode:self.scene];
    self.touchoffset = location;
    self.pressed = true;
    self.displacement = CGPointMake(0, 0);
}

-(void) touchunbind:(UITouch*) touch {
    if (self.touch != touch) {
        return;
    }
    
    self.touch = nil;
    self.pressed = false;
    self.displacement = CGPointMake(0, 0);
}

-(void) drag{
    if (self.isdragged == NO) return;
    
    CGPoint location = [self.touch locationInNode:self.scene];
    
    self.displacement = CGPointMake(location.x - self.touchoffset.x, location.y - self.touchoffset.y);
    self.touchoffset = location;
}

@end

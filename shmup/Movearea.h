//
//  Movearea.h
//  shmup
//
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Movearea : SKSpriteNode

@property (nonatomic, assign) NSUInteger identity;
@property (nonatomic) CGPoint touchoffset;
@property (nonatomic, weak) UITouch *touch;
@property (nonatomic, readonly) BOOL isdragged;
@property (nonatomic) bool pressed;
@property (nonatomic) CGPoint displacement;

-(SKSpriteNode*) initWithColor:(UIColor*)color andSize:(CGSize)size andID:(NSUInteger)id andPosition:(CGPoint)position;

-(void)touchBind:(UITouch*) touch;
-(void)touchunbind:(UITouch*) touch;
-(void)drag;

@end

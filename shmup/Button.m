//
//  Button.m
//  shmup
//
//  Created by Yuya Takeuchi on 2014/08/16.
//  Copyright (c) 2014年 Yuya Takeuchi. All rights reserved.
//

#import "Button.h"

@implementation Button

-(Button*)init:(CGSize)initSize withPosition:(CGPoint)initPos andName:(NSString*)initName{
    self = [super initWithColor:[UIColor redColor] size:initSize];
    self.position = initPos;
    self.name = initName;
    self.zPosition = 110;
    return self;
}

@end

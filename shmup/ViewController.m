//
//  ViewController.m
//  shmup
//  LAST EDIT: 12/08/14
//  FUNCTIONAL VER.
//  Created by Yuya Takeuchi on 2014/04/20.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MenuScene.h"
@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    MenuScene *welcome = [[MenuScene alloc]
                          initWithSize:CGSizeMake(skView.bounds.size.width,
                                                  skView.bounds.size.height)];
    
    [skView presentScene:welcome];
    
    // Create and configure the scene.
    //SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    //[skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

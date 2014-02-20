//
//  YKRViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-12.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRMainViewController.h"
#import "YKRMainMenuScene.h"
#import "YKRSessionManager.h"
#import "YKRSessionTableViewController.h"


@implementation YKRMainViewController
{
    BOOL gameInProgress;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    //[skView setBackgroundColor:];
    
    // Create and configure the scene.
    YKRMainMenuScene * scene = [YKRMainMenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setViewController:self];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)viewDidAppear:(BOOL)animated
{/*
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self performSegueWithIdentifier:@"segueToSessionTableViewController" sender:nil];
    });*/
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [(YKRScene *)[(SKView *)[self view] scene] sceneOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToSessionViewTableController"]) {
        
    }
}

- (IBAction)unwindToGameViewControllerFrom:(UIStoryboardSegue *)segue
{
    if ([segue sourceViewController]) {}
}

@end

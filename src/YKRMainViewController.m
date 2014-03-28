//
//  YKRViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-12.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "YKRMainViewController.h"
#import "YKRMainMenuScene.h"
#import "YKRAppDelegate.h"
#import "YKRGameManager.h"


@implementation YKRMainViewController
{
    BOOL gameInProgress;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)[self view];
    [skView setShowsFPS:YES];
    [skView setShowsNodeCount:YES];
    
    // Create and configure the scene.
    YKRMainMenuScene * scene = [YKRMainMenuScene sceneWithSize:[skView bounds].size];
    [scene setScaleMode:SKSceneScaleModeAspectFill];
    [scene setParentViewController:self];
    
    // Present the scene.
    [skView presentScene:scene];
}

- (void)viewDidAppear:(BOOL)animated
{
    
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

- (IBAction)unwindToMainViewControllerFrom:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"unwindSegueToMainViewControllerFromLobbyTableViewController"]) {
        id<YKRNetworking> networking = [(YKRAppDelegate *)[[UIApplication sharedApplication] delegate] networkController];
        NSString * gameType = [[[networking game] class] typeName];
        NSLog(@"Presenting game type scene %@", gameType);
        /// @todo: This is hard coded lol:
        SKScene * scene = [[YKRGameManager sharedManager] sceneForGameType:@"Euchre"];
        NSLog(@"scene = %@", scene);
        [(SKView *)[self view] presentScene:scene];
    }
}

@end

//
//  YKRLobbyTableViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-03-21.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRLobbyTableViewController.h"
#import "YKRGame.h"
#import "YKRPlayer.h"
#import "YKRAppDelegate.h"


@implementation YKRLobbyTableViewController
@synthesize delegate;

- (void)playerAdded:(id)sender
{
    [[self tableView] reloadData];
}

- (void)playerRemoved:(id)sender
{
    [[self tableView] reloadData];
}

#pragma mark - Segues

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"unwindSegueToSessionTableViewControllerFromLobbyTableViewController"]) {
        /// @todo: We're leaving the lobby, kill the networkController.
    }
    
    return YES;
}

#pragma mark - UITableViewDelegate methods

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([indexPath section] == 2);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[[tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqualToString:@"startGameTableViewCell"]) {
        // It's happening!
    }
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if ([indexPath section] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"networkGamePlayerTableViewCell"];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"Player %ld", ([indexPath row] + 1)]];
        UILabel * detailLabel = [cell detailTextLabel];
        
        NSString * playerName = [[[[[self delegate] game] players] objectAtIndex:[indexPath row]] name];
        
        if (playerName) {
            [detailLabel setText:playerName];
        }
        else {
            [detailLabel setText:@"waiting…"];
            [detailLabel setTextColor:[UIColor lightGrayColor]];
            [detailLabel setFont:[UIFont italicSystemFontOfSize:[[detailLabel font] pointSize]]];
        }
    }
    else if ([indexPath section] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"waitingForPlayersTableViewCell"];
    }
    else if ([indexPath section] == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"startGameTableViewCell"];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // If we have a fixed game size, the game will start automatically when the lobby fills up.
    // If not, we need to display a "start game" button if this lobby is attached to the host.
    /// @todo: Restore the proper check here:
    /*
    if ([[[self delegate] game] gameSize] == 0 && [[self delegate] isHostingGame]) {
        return 3; // Players, waiting, start game.
    }
    else {
        return 2; // Players, waiting.
    }
     */
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Current Players";
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // If we have a fixed game size, we want to create "waiting" cells. If not, just show current players.
        if ([[[self delegate] game] gameSize] > 0) {
            NSLog(@"number of rows = gamesize: %ld", [[[self delegate] game] gameSize]);
            return [[[self delegate] game] gameSize];
        }
        else {
            NSLog(@"appdelegate thing %@", [(YKRAppDelegate *)[[UIApplication sharedApplication] delegate] networkController]);
            NSLog(@"delegate %@", [self delegate]);
            NSLog(@"game %@", [[self delegate] game]);
            NSLog(@"number of rows = playercount: %ld", [[[self delegate] game] playerCount]);
            return [[[self delegate] game] playerCount];
        }
    }
    
    return 1;
}

#pragma mark - Plumbing

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAdded:) name:@"YKRGame_addedPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerRemoved:) name:@"YKRGame_removedPlayer" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YKRGame_addedPlayer" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YKRGame_removedPlayer" object:nil];
}

@end

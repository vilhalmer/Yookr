//
//  YKRNetworkGameTableViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-14.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRNetworkGameTableViewController.h"
#import "YKRClient.h"
#import "YKRAppDelegate.h"
#import "YKRLobbyTableViewController.h"


@implementation YKRNetworkGameTableViewController
{
    YKRClient * client;
}
@synthesize session;

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"networkGameTableViewController session = %@", [self session]);
    client = [[YKRClient alloc] initWithSession:[self session]];
    [client connect];
    YKRRemoteGame * remoteGame = [YKRRemoteGame new];
    [remoteGame setRemoteDelegate:client];
    [remoteGame setGameSize:[[[self session] gameSize] integerValue]];
    [client setGame:remoteGame];
}

- (void)viewDidAppear:(BOOL)animated
{
    /// @todo: Stop hacking around the preview lobby.
    if ([self isMovingToParentViewController]) {
        [self performSegueWithIdentifier:@"segueToLobbyTableViewController" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToLobbyTableViewController"]) {
        NSLog(@"setting lobby delegate n' stuff");
        [(YKRAppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkController:client];
        [(YKRLobbyTableViewController *)[(UINavigationController *)[segue destinationViewController] topViewController] setDelegate:client];
    }
}

#pragma mark - UITableViewDataSource methods

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1 && [indexPath row] == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if ([indexPath section] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"networkGamePlayerTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                          reuseIdentifier:@"networkGamePlayerTableViewCell"];
        }
        
        NSString * playerName = [[[client game] players] objectAtIndex:[indexPath row]];
        
        [[cell textLabel] setText:[NSString stringWithFormat:@"Player %ld", [indexPath row] + 1]];
        [[cell detailTextLabel] setText:playerName];
    }
    else if ([indexPath section] == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"joinGameTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"joinGameTableViewCell"];
            [[cell textLabel] setText:@"Join Game"];
            [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
            [[cell textLabel] setTintColor:[[self view] tintColor]];
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // Players, join game.
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
        if ([[client game] gameSize] > 0) {
            return [[client game] gameSize];
        }
        else {
            NSLog(@"probably here?");
            return [[client game] playerCount];
        }
    }
    else {
        return 1;
    }
}

@end

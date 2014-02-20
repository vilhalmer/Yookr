//
//  YKRSessionViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-13.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSessionTableViewController.h"
#import "YKRSessionManager.h"


@implementation YKRSessionTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [[YKRSessionManager sharedSessionManager] beginScanningForSessions];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[YKRSessionManager sharedSessionManager] stopScanningForSessions];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToNetworkGameViewController"]) {
        // Pass network game object to controller for display.
    }
}

- (IBAction)unwindToSessionTableViewControllerFrom:(UIStoryboardSegue *)segue
{
    NSLog(@"uuuunnnwiiiiiiinnd");
}

- (IBAction)rescan:(id)sender
{
    [self newSessionAvailable:nil];
}

- (void)newSessionAvailable:(id)sender
{
    [[self tableView] reloadData];
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if ([indexPath section] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"newGameTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"newGameTableViewCell"];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"networkGameTableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:@"networkGameTableViewCell"];
        }
        
        YKRSession * session = [[[YKRSessionManager sharedSessionManager] availableSessions] objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[session name]];
        [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%ld/4 players", [[session playerCount] integerValue]]];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2; // Network games, create game.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Available Games";
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return [[[YKRSessionManager sharedSessionManager] availableSessions] count];
    }
    else {
        return 1;
    }
}

#pragma mark - Plumbing

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSessionAvailable:) name:@"YKRSessionManager_newSession" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YKRSessionManager_newSession" object:nil];
}

@end

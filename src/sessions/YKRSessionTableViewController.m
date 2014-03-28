//
//  YKRSessionViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-13.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSessionTableViewController.h"
#import "YKRSessionManager.h"
#import "YKRGameManager.h"
#import "YKRNetworkGameTableViewController.h"


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
    if ([[segue identifier] isEqualToString:@"segueToNetworkGameTableViewController"]) {
        NSIndexPath * indexPath = [[self tableView] indexPathForCell:sender];
        YKRSession * selectedSession = [[[YKRSessionManager sharedSessionManager] availableSessionsOfType:[[YKRGameManager sharedManager] gameTypes][[indexPath section] - 1]] objectAtIndex:[indexPath row]];
        [(YKRNetworkGameTableViewController *)[segue destinationViewController] setSession:selectedSession];
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

- (void)sessionRemoved:(id)sender
{
    [[self tableView] reloadData];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
        
        /// @todo: Holy shit please fix this
        YKRSession * session = [[[YKRSessionManager sharedSessionManager] availableSessionsOfType:[[YKRGameManager sharedManager] gameTypes][[indexPath section] - 1]] objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[session name]];
        NSString * playerCountString;
        if ([[session gameSize] integerValue] > 0) {
            playerCountString = [NSString stringWithFormat:@"%ld/%ld players", [[session playerCount] integerValue], [[session gameSize] integerValue]];
        }
        else {
            playerCountString = [NSString stringWithFormat:@"%ld players", [[session playerCount] integerValue]];
        }
        
        [[cell detailTextLabel] setText:playerCountString];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /// @todo: This is naïve, we should only be displaying sections with at least one game available.
    return [[[YKRGameManager sharedManager] gameTypes] count] + 1; // Create game, and one per game type.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return [[YKRGameManager sharedManager] gameTypes][section - 1];
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section > 0) {
        NSString * gameType = [[YKRGameManager sharedManager] gameTypes][section - 1];
        return [[[YKRSessionManager sharedSessionManager] availableSessionsOfType:gameType] count];
    }
    
    return 1;
}

#pragma mark - Plumbing

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSessionAvailable:) name:@"YKRSessionManager_newSession" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRemoved:) name:@"YKRSessionManager_removeSession" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YKRSessionManager_newSession" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"YKRSessionManager_removeSession" object:nil];
}

@end

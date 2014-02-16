//
//  YKRNetworkGameTableViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-14.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRNetworkGameTableViewController.h"

@implementation YKRNetworkGameTableViewController
{
    // YKRGame * game;
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
        // Now launch the lobby view.
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
        
        NSString * playerName;
        switch ([indexPath row]) {
            case 0:
                playerName = @"Rose Lalonde";
                break;
            case 1:
                playerName = @"Dave Strider";
                break;
            case 2:
                playerName = @"Jade Harley";
                break;
            case 3:
                playerName = @"John Egbert";
                break;
            default:
                playerName = @"Karkat Vantas"; // WHY THE FUCK AM I THE DEFAULT
                break;
        }
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
        return 4;
    }
    else {
        return 1;
    }
}

@end

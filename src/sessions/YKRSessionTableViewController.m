//
//  YKRSessionViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-13.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRSessionTableViewController.h"

@implementation YKRSessionTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToNetworkGameViewController"]) {
        // Pass network game object to controller for display.
    }
}

- (IBAction)unwindToSessionTableViewControllerFrom:(UIStoryboardSegue *)segue
{
    NSLog(@"hi");
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
        
        [[cell textLabel] setText:@"TEST YO"];
        [[cell detailTextLabel] setText:@"0/4 players"];
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
        return 3;
    }
    else {
        return 1;
    }
}

@end

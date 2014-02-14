//
//  YKRNewGameTableViewController.m
//  Yookr
//
//  Created by Bill Doyle on 2014-02-14.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRNewGameTableViewController.h"

@implementation YKRNewGameTableViewController
{
    IBOutlet UITextField * nameField;
    IBOutlet UILabel * gameTypeLabel;
    IBOutlet UILabel * numberOfPlayersLabel;
    IBOutlet UITableViewCell * createGameCell;
}

#pragma mark - UITableViewDelegate methods

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0 && [indexPath row] == 1) {
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

#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField text] isEqualToString:@""]) {
        [createGameCell setUserInteractionEnabled:NO];
        [[createGameCell textLabel] setEnabled:NO];
    }
    else {
        [createGameCell setUserInteractionEnabled:YES];
        [[createGameCell textLabel] setEnabled:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[textField text] isEqualToString:@""]) {
        UIView * maybeCell = textField;
        while (![maybeCell isKindOfClass:[UITableViewCell class]]) { // Walk up to the table cell containing the field.
            maybeCell = [maybeCell superview];
        }
        NSIndexPath * indexPath = [[self tableView] indexPathForCell:(UITableViewCell *)maybeCell];
        [[self tableView] selectRowAtIndexPath:indexPath
                                      animated:NO
                                scrollPosition:UITableViewScrollPositionNone];
        [[self tableView] deselectRowAtIndexPath:indexPath animated:YES];
        return NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end

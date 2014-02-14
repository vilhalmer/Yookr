//
//  YKRPortraitTableViewController.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-14.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKRPortraitTableViewController : UITableViewController

#pragma mark - Orientation

- (UIStatusBarStyle)preferredStatusBarStyle;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;

@end

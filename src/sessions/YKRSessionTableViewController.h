//
//  YKRSessionViewController.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-13.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKRPortraitTableViewController.h"

@interface YKRSessionTableViewController : YKRPortraitTableViewController

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end

//
//  YKRNetworkGameTableViewController.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-14.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKRSession.h"


@interface YKRNetworkGameTableViewController : UITableViewController

@property (readwrite, strong) YKRSession * session;

@end

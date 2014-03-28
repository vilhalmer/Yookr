//
//  YKRLobbyTableViewController.h
//  Yookr
//
//  Created by Bill Doyle on 2014-03-21.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import "YKRPortraitTableViewController.h"
#import "YKRNetworking.h"


@interface YKRLobbyTableViewController : YKRPortraitTableViewController

@property (readwrite, weak) id<YKRNetworking> delegate;

@end

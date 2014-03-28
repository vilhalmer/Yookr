//
//  YKRAppDelegate.h
//  Yookr
//
//  Created by Bill Doyle on 2014-02-12.
//  Copyright (c) 2014 Unsquared Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKRNetworking.h"


@interface YKRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property (readwrite, strong) id<YKRNetworking> networkController;

@end

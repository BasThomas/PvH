//
//  BTBAppDelegate.h
//  PvHApp
//
//  Created by Arnold Broek on 10/04/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHUser.h"

@interface BTBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic)PVHUser *currentUser;

@end

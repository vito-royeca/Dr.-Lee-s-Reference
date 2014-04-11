//
//  AppDelegate.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) MMDrawerController *drawerController;
@property(strong,nonatomic) UIWindow *window;

@end

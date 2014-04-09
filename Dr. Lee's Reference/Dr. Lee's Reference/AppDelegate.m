//
//  AppDelegate.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MMDrawerController.h"
#import "DictionaryViewController.h"


@interface AppDelegate()
@property (nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self setupDb:@"database.sqlite"];
    
//    MenuViewController *menuVC = [[MenuViewController alloc] init];
//    DictionaryViewController *dictionaryVC = [[DictionaryViewController alloc] initWithNibName:nil bundle:nil];
//    MMDrawerController *mainVC = [[MMDrawerController alloc] initWithCenterViewController:dictionaryVC
//                                                                   leftDrawerViewController:menuVC];
//    self.window.rootViewController = mainVC;
//    
//    [self.window makeKeyAndVisible];
//    return YES;
    
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    DictionaryViewController *dictionaryVC = [[DictionaryViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:dictionaryVC];
    
    [navigationController setRestorationIdentifier:@"CenterNavigationControllerRestorationKey"];
    if(OSVersionIsAtLeastiOS7())
    {
        UINavigationController * leftSideNavController = [[UINavigationController alloc] initWithRootViewController:menuVC];
		[leftSideNavController setRestorationIdentifier:@"LeftNavigationControllerRestorationKey"];
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:navigationController
                                 leftDrawerViewController:leftSideNavController];
        [self.drawerController setShowsShadow:NO];
    }
    else
    {
        self.drawerController = [[MMDrawerController alloc]
                                 initWithCenterViewController:navigationController
                                 leftDrawerViewController:menuVC];
    }
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
//    [self.drawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController, drawerSide, percentVisible);
//         }
//     }];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7())
    {
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    [self.window setRootViewController:self.drawerController];
    
    return YES;
}

- (void) setupDb:(NSString*) dbname
{
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [paths lastObject];
    NSURL *storeURL = [documentPath URLByAppendingPathComponent:dbname];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[dbname stringByDeletingPathExtension] ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err])
        {
            NSLog(@"Error: Unable to copy preloaded database.");
        }
    }
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:dbname];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.

//    [[Database sharedInstance] saveContext];
    [MagicalRecord cleanUp];

}

@end

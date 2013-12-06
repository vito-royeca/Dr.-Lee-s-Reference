//
//  AppDelegate.m
//  DataLoader
//
//  Created by Jovito Royeca on 12/2/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

//    DrugsLoader *loader = [[DrugsLoader alloc] init];
//    [loader loadDrugs];
    
    StedmansScraper *sc = [[StedmansScraper alloc] init];
    [sc scrape];
}

@end

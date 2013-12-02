//
//  TabBarController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()
{
    SearchViewController *_searchView;
}
@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITabBarItem *tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    _searchView = [[SearchViewController alloc] init];
    [_searchView setTabBarItem:tab];
    UINavigationController *_searchNavView = [[UINavigationController alloc] initWithRootViewController:_searchView];
    
    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    UIViewController *browseView = [[UIViewController alloc] init];
    [browseView setTabBarItem:tab];
    
    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    UIViewController *favoritesView = [[UIViewController alloc] init];
    [favoritesView setTabBarItem:tab];
    
    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    UIViewController *historyView = [[UIViewController alloc] init];
    [historyView setTabBarItem:tab];
    
    
    [self setViewControllers:[NSArray arrayWithObjects:_searchNavView, browseView, favoritesView, historyView, nil]];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"Loading...";
    [self.view addSubview:hud];
    hud.delegate = self;
    [hud showWhileExecuting:@selector(loadDatabase) onTarget:self withObject:nil animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
}

-(void) loadDatabase
{
//    DrugsLoader *loader = [[DrugsLoader alloc] init];
//    [loader loadDrugs];
//    [loader downloadDocuments];
    
//    StedmansScraper *sc = [[StedmansScraper alloc] init];
//    [sc scrape];
//    [Database sharedInstance];
}

@end

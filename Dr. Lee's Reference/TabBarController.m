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
    tab.title = @"Search";
    UINavigationController *_searchNavView = [[UINavigationController alloc] initWithRootViewController:_searchView];
    
    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    UIViewController *_drugsView = [[UIViewController alloc] init];
    [_drugsView setTabBarItem:tab];
    tab.title = @"Drugs";
    
    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:2];
    UIViewController *_icd10View = [[UIViewController alloc] init];
    [_icd10View setTabBarItem:tab];
    tab.title = @"ICD-10";
    
//    tab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:3];
    UIViewController *_favoritesView = [[UIViewController alloc] init];
//    [_favoritesView setTabBarItem:tab];
//    tab.title = @"Favorites";
    
    [self setViewControllers:[NSArray arrayWithObjects:_searchNavView, _drugsView, _icd10View, _favoritesView, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

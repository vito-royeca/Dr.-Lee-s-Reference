//
//  MainViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "MainViewController.h"
#import "BrowseViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    
    UINavigationController *nc1 = [[UINavigationController alloc] init];
    UIViewController *vc1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    vc1.view.backgroundColor = [UIColor greenColor];
    nc1.viewControllers = [NSArray arrayWithObjects:vc1, nil];
    nc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search"
                                                   image:[UIImage imageNamed:@"search.png"]
                                           selectedImage:[UIImage imageNamed:@"search.png"]];
    
    UINavigationController *nc2 = [[UINavigationController alloc] init];
    UIViewController *vc2 = [[BrowseViewController alloc] initWithNibName:nil bundle:nil];
    vc2.view.backgroundColor = [UIColor yellowColor];
    nc2.viewControllers = [NSArray arrayWithObjects:vc2, nil];
    nc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Browse"
                                                   image:[UIImage imageNamed:@"opened_folder.png"]
                                           selectedImage:[UIImage imageNamed:@"opened_folder.png"]];
    
    UINavigationController *nc3 = [[UINavigationController alloc] init];
    UIViewController *vc3 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    vc3.view.backgroundColor = [UIColor orangeColor];
    nc3.viewControllers = [NSArray arrayWithObjects:vc3, nil];
    nc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites"
                                                   image:[UIImage imageNamed:@"star.png"]
                                           selectedImage:[UIImage imageNamed:@"star.png"]];
    
    UINavigationController *nc4 = [[UINavigationController alloc] init];
    UIViewController *vc4 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    vc4.view.backgroundColor = [UIColor purpleColor];
    nc4.viewControllers = [NSArray arrayWithObjects:vc4, nil];
    nc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History"
                                                   image:[UIImage imageNamed:@"safari.png"]
                                           selectedImage:[UIImage imageNamed:@"safari.png"]];
    
    self.viewControllers = [NSArray arrayWithObjects:nc1, nc2, nc3, nc4, nil];
    self.selectedViewController = nc1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

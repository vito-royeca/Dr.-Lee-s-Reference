//
//  DictionaryViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/9/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DictionaryViewController.h"

@interface DictionaryViewController ()

@end

@implementation DictionaryViewController

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
    [nc1.navigationBar setTintColor:[UIColor blackColor]];
    UIViewController *viewController1 = [[DictionaryBrowseViewController alloc] initWithNibName:nil bundle:nil];
    nc1.viewControllers = [NSArray arrayWithObjects:viewController1, nil];
    [nc1.navigationBar setTintColor:[UIColor yellowColor]];
    nc1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
//    nc1.tabBarItem.title = @"Browse";
//    nc1.tabBarItem.image =
    
    UINavigationController *nc2 = [[UINavigationController alloc] init];
    [nc2.navigationBar setTintColor:[UIColor blackColor]];
    UIViewController *viewController2 = [[DictionarySearchViewController alloc] initWithNibName:nil bundle:nil];
    nc2.viewControllers = [NSArray arrayWithObjects:viewController2, nil];
    nc2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
	tabBarController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:nc1, nc2 ,nil];
    [self.view addSubview:tabBarController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

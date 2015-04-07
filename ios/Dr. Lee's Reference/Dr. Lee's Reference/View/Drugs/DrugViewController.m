//
//  DrugViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/11/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DrugViewController.h"
#import "DrugBrowseViewController.h"
#import "DrugSearchViewController.h"

@interface DrugViewController ()

@end

@implementation DrugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *nc1 = [[UINavigationController alloc] init];
    UIViewController *vc1 = [[DrugSearchViewController alloc] initWithNibName:nil bundle:nil];
    nc1.viewControllers = [NSArray arrayWithObjects:vc1, nil];
    nc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search"
                                                   image:[UIImage imageNamed:@"search.png"]
                                           selectedImage:[UIImage imageNamed:@"search.png"]];
    
    UINavigationController *nc2 = [[UINavigationController alloc] init];
    UIViewController *vc2 = [[DrugBrowseViewController alloc] initWithNibName:nil bundle:nil];
    nc2.viewControllers = [NSArray arrayWithObjects:vc2, nil];
    nc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Browse"
                                                   image:[UIImage imageNamed:@"box.png"]
                                           selectedImage:[UIImage imageNamed:@"box.png"]];
    
    self.viewControllers = [NSArray arrayWithObjects:nc1, nc2 ,nil];
    self.selectedViewController = nc1;
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

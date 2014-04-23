//
//  MenuViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/18/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "SearchSettingsViewController.h"
#import "AppDelegate.h"
#import "DictionaryViewController.h"
#import "DrugViewController.h"
#import "MMSideDrawerTableViewCell.h"

@interface SearchSettingsViewController ()

@end

@implementation SearchSettingsViewController

@synthesize tblMenu = _tblMenu;
@synthesize drawerWidths = _drawerWidths;

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
    
    if(OSVersionIsAtLeastiOS7())
    {
        self.tblMenu = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    else
    {
        self.tblMenu = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    [self.tblMenu setDelegate:self];
    [self.tblMenu setDataSource:self];
    [self.view addSubview:self.tblMenu];
//    [self.tblMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
//    UIColor * tableViewBackgroundColor;
//    if(OSVersionIsAtLeastiOS7())
//    {
//        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
//                                                   green:113.0/255.0
//                                                    blue:115.0/255.0
//                                                   alpha:1.0];
//    }
//    else
//    {
//        tableViewBackgroundColor = [UIColor colorWithRed:77.0/255.0
//                                                   green:79.0/255.0
//                                                    blue:80.0/255.0
//                                                   alpha:1.0];
//    }
//    [self.tblMenu setBackgroundColor:tableViewBackgroundColor];
//    
//    [self.tblMenu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
//                                                  green:69.0/255.0
//                                                   blue:71.0/255.0
//                                                  alpha:1.0]];
//    
//    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
//                                         green:164.0/255.0
//                                          blue:166.0/255.0
//                                         alpha:1.0];
//    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
//    {
//        [self.navigationController.navigationBar setBarTintColor:barColor];
//    }
//    else
//    {
//        [self.navigationController.navigationBar setTintColor:barColor];
//    }
//    
//    
//    NSDictionary *navBarTitleDict;
//    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
//                                           green:70.0/255.0
//                                            blue:77.0/255.0
//                                           alpha:1.0];
//    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
//    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
//    
//    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
//    
//    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.navigationItem.title = @"Search Settings";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tblMenu reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tblMenu.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentSizeDidChange:(NSString *)size
{
    [self.tblMenu reloadData];
}

#pragma mark - TableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        cell.textLabel.textColor = kMenuFontColor;
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	}
	
	if (row == 0)
	{
		cell.textLabel.text = kAppTitle;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
	}
    else if (row == 1)
	{
		cell.textLabel.text = kDictionaryTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"literature.png"];
	}
	else if (row == 2)
	{
		cell.textLabel.text = kDrugsTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"pill.png"];
	}
    else if (row == 3)
	{
		cell.textLabel.text = kICD10Title;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"brick.png"];
	}
	else if (row == 4)
	{
		cell.textLabel.text = kFavoritesTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"star.png"];
	}
	else if (row == 5)
	{
		cell.textLabel.text = kHistoryTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"safari.png"];
	}
	else if (row == 6)
	{
		cell.textLabel.text = kSettingsTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"settings.png"];
	}
    else if (row == 7)
	{
		cell.textLabel.text = kAboutTitle;
//        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"info.png"];
	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UIViewController *viewController;
    
    switch (row)
    {
        case 1:
        {
            viewController = [[DictionaryViewController alloc] init];
            break;
        }
        case 2:
        {
            viewController = [[DrugViewController alloc] init];
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
    }
    
    if (viewController)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDelegate.drawerController setCenterViewController:viewController];
        [appDelegate.drawerController closeDrawerAnimated:YES completion:nil];
    }
    
}

@end

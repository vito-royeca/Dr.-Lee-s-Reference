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

@interface SearchSettingsViewController ()

@end

@implementation SearchSettingsViewController

@synthesize tblMenu = _tblMenu;
@synthesize arrDataSource = _arrDataSource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.arrDataSource = @[@"Dictionary",
                           @"FDA Drugs",
                           @"ICD10-CM",
                           @"ICD10-PCS"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tblMenu = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tblMenu.delegate = self;
    self.tblMenu.dataSource = self;
    
    
    [self.view addSubview:self.tblMenu];
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
	return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
    cell.textLabel.text = [self.arrDataSource objectAtIndex:row];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
//    NSInteger row = indexPath.row;
//    UIViewController *viewController;
//    
//    switch (row)
//    {
//        case 1:
//        {
//            viewController = [[DictionaryViewController alloc] init];
//            break;
//        }
//        case 2:
//        {
//            viewController = [[DrugViewController alloc] init];
//            break;
//        }
//        case 3:
//        {
//            break;
//        }
//        case 4:
//        {
//            break;
//        }
//    }
//    
//    if (viewController)
//    {
//        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//        [appDelegate.drawerController setCenterViewController:viewController];
//        [appDelegate.drawerController closeDrawerAnimated:YES completion:nil];
//    }
}

@end

//
//  BrowseViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "BrowseViewController.h"
#import "DictionaryBrowseViewController.h"
#import "FDADrugsBrowseViewController.h"
#import "ICD10CMBrowseViewController.h"
#import "ICD10PCSBrowseViewController.h"
#import "RADataObject.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

@synthesize data = _data;
@synthesize tblBrowse = _tblBrowse;

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
    self.data = @[@"Dictionary",
                  @"FDA Drugs",
                  @"ICD10 CM",
                  @"ICD10 PCS"];
    
    self.tblBrowse = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tblBrowse.delegate = self;
    self.tblBrowse.dataSource = self;
    
    [self.view addSubview:self.tblBrowse];
    self.navigationItem.title = @"Browse";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController;
    
    switch (indexPath.row)
    {
        case 0:
        {
            viewController = [[DictionaryBrowseViewController alloc] initWithNibName:nil bundle:nil];
            break;
        }
        case 1:
        {
            viewController = [[FDADrugsBrowseViewController alloc] initWithNibName:nil bundle:nil];
            break;
        }
        case 2:
        {
            viewController = [[ICD10CMBrowseViewController alloc] initWithNibName:nil bundle:nil];
            break;
        }
        case 3:
        {
            viewController = [[ICD10PCSBrowseViewController alloc] initWithNibName:nil bundle:nil];
            break;
        }
        default:
        {
            break;
        }
    }
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:NO];
    }
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

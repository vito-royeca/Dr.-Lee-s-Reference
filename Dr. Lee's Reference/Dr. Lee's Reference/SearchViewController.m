//
//  SearchViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    NSArray *_letters;
    NSArray *_keys;
    NSMutableDictionary *_content;
}
@end

@implementation SearchViewController

@synthesize searchBar;
@synthesize tblResults;
@synthesize results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.title = @"Dr. Lee's Reference";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _letters = [NSArray arrayWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
               @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
               @"V", @"W", @"X", @"Y", @"Z", nil];
    _content = [[NSMutableDictionary alloc] init];

    
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat currentWidth = self.view.frame.size.width;
    CGFloat currentHeight = 100;
    CGRect frame = CGRectMake(currentX, currentY, currentWidth, currentHeight);
    searchBar = [[UISearchBar alloc] initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Dictionary", @"Drugs", @"ICD-10", nil];
    searchBar.showsScopeBar = YES;
    [self.view addSubview:searchBar];
    
    currentY = searchBar.frame.size.height;
    currentHeight = self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height-100;
    frame = CGRectMake(currentX, currentY, currentWidth, currentHeight);
    tblResults = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tblResults.delegate = self;
    tblResults.dataSource = self;
    tblResults.scrollEnabled = YES;
    tblResults.userInteractionEnabled = YES;
    [self.view addSubview:tblResults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSections
{
    [_content removeAllObjects];
    
    for (NSString *letter in _letters)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        switch (searchBar.selectedScopeButtonIndex)
        {
            case DictionaryDataSource:
            {
                for (Dictionary *d in results)
                {
                    if ([d.term hasPrefix:letter])
                    {
                        if (![values containsObject:d])
                        {
                            [values addObject:d];
                        }
                    }
                }
                break;
            }
            case DrugsDataSource:
            {
                for (NSDictionary *dict in results)
                {
                    NSString *name = [dict objectForKey:@"Drug Name"];
                    
                    if ([name hasPrefix:letter])
                    {
                        if (![values containsObject:dict])
                        {
                            [values addObject:dict];
                        }
                    }
                }
                break;
            }
            default:
            {
                break;
            }
        }
        
        if (values.count > 0)
        {
            [_content setValue:values forKey:letter];
        }
    }
    
    _keys =  [[_content allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

#pragma - mark UITableViewDataSource
- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [_keys indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *prefix = [_keys objectAtIndex:section];
    NSArray *list = [_content objectForKey:prefix];
    return list.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UILabel *lblHeader = [[UILabel alloc] init];
    
    lblHeader.text = [_keys objectAtIndex:section];
    lblHeader.backgroundColor = [UIColor lightGrayColor];
    lblHeader.textColor = [UIColor lightTextColor];
    lblHeader.userInteractionEnabled = YES;
    [lblHeader setTag:section+1];
    return lblHeader;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_keys objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *prefix = [_keys objectAtIndex:indexPath.section];
    NSArray *arr = [_content objectForKey:prefix];
    
    switch (searchBar.selectedScopeButtonIndex)
    {
        case DictionaryDataSource:
        {
            Dictionary *d = [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = d.term;
            cell.detailTextLabel.text = @"";
            break;
        }
        case DrugsDataSource:
        {
            NSDictionary *dict = [arr objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [dict objectForKey:@"Drug Name"];
            cell.detailTextLabel.text = [dict objectForKey:@"Active Ingredient(s)"];
            break;
        }
        default:
        {
            break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *prefix = [_keys objectAtIndex:indexPath.section];
    NSArray *arr = [_content objectForKey:prefix];
    
    DrugSummaryViewController *summaryVC = [[DrugSummaryViewController alloc] init];
    summaryVC.drugSummary = [arr objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:summaryVC animated:YES];
}

-(void) search
{
    if ([searchBar canResignFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    
    results = [[Database sharedInstance] search:searchBar.selectedScopeButtonIndex query:searchBar.text];
    [self createSections];
    
    [tblResults reloadData];
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", results.count];
}

-(void) performSearchOnMainThread
{
    [self performSelectorOnMainThread:@selector(search) withObject:nil waitUntilDone:YES];
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0),
//    ^{
//        [self performSearchOnMainThread];
//        
//        dispatch_async(dispatch_get_main_queue(),
//        ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    });
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    [hud showWhileExecuting:@selector(performSearchOnMainThread) onTarget:self withObject:nil animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)bar
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    [hud showWhileExecuting:@selector(performSearchOnMainThread) onTarget:self withObject:nil animated:YES];
}

@end

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
    CGFloat currentHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect frame = CGRectMake(currentX, currentY, currentWidth, currentHeight);
    searchBar = [[UISearchBar alloc] initWithFrame:frame];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.delegate = self;
    searchBar.placeholder = @"search dictionary";
    
    currentHeight = self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height;
    frame = CGRectMake(currentX, currentY, currentWidth, currentHeight);
    tblResults = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tblResults.delegate = self;
    tblResults.dataSource = self;
    tblResults.scrollEnabled = YES;
    tblResults.userInteractionEnabled = YES;
    [self.view addSubview:tblResults];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    self.navigationItem.titleView = searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSections
{
    [_content removeAllObjects];
    
    NSMutableArray *arrNonAlpha = [[NSMutableArray alloc] init];
    
    for (NSString *letter in _letters)
    {
        NSMutableArray *arrValues = [[NSMutableArray alloc] init];
        
        switch (searchBar.selectedScopeButtonIndex)
        {
            case DictionaryDataSource:
            {
                for (DictionaryTerm *d in results)
                {
                    NSString *term = [Util toASCII:d.term];
                    
                    if ([Util isAlphaStart:term])
                    {
                        if ([[term uppercaseString] hasPrefix:letter])
                        {
                            if (![arrValues containsObject:d])
                            {
                                [arrValues addObject:d];
                            }
                        }
                    }
                    else
                    {
                        if (![arrNonAlpha containsObject:d])
                        {
                            [arrNonAlpha addObject:d];
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
                    
                    if ([[name uppercaseString] hasPrefix:letter])
                    {
                        if (![arrValues containsObject:dict])
                        {
                            [arrValues addObject:dict];
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
        
        if (arrValues.count > 0)
        {
            [_content setValue:arrValues forKey:letter];
        }
    }

    if (arrNonAlpha.count > 0)
    {
        [_content setValue:arrNonAlpha forKey:@"#"];
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
    
    NSMutableString *text = [[NSMutableString alloc] init];
    NSString *letter = [_keys objectAtIndex:section];
    [text appendFormat:@"%@ (%d of %d)", letter, [[_content valueForKey:letter] count], [results count]];
    lblHeader.text = text;
    lblHeader.backgroundColor = kMenuBackgroundColor;
    lblHeader.textColor = kMenuFontColor;
    lblHeader.font = kMenuFont;
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
            DictionaryTerm *d = [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = d.term;
            cell.detailTextLabel.text = @"";
            cell.textLabel.font = kMenuFont;
            cell.detailTextLabel.font = kMenuFont;
            break;
        }
        case DrugsDataSource:
        {
            NSDictionary *dict = [arr objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [dict objectForKey:@"Drug Name"];
            cell.detailTextLabel.text = [dict objectForKey:@"Active Ingredient(s)"];
            cell.textLabel.font = kMenuFont;
            cell.detailTextLabel.font = kMenuFont;
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
    
    switch (searchBar.selectedScopeButtonIndex)
    {
        case DictionaryDataSource:
        {
            DictionaryTermViewController *viewController = [[DictionaryTermViewController alloc] init];
            viewController.dictionaryTerm = [arr objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case DrugsDataSource:
        {
            DrugSummaryViewController *viewController = [[DrugSummaryViewController alloc] init];
            viewController.drugSummary = [arr objectAtIndex:indexPath.row];
            
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
        default:
        {
            break;
        }
    }
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

//- (void)searchBarTextDidEndEditing:(UISearchBar *)bar
//{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    hud.delegate = self;
//    [hud showWhileExecuting:@selector(performSearchOnMainThread) onTarget:self withObject:nil animated:YES];
//}

@end

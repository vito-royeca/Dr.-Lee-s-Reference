//
//  DrugSearchViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/11/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DrugSearchViewController.h"
#import "DrugSummaryViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "Product.h"
#import "UIViewController+MMDrawerController.h"

@interface DrugSearchViewController ()
{
    NSArray *_letters;
    NSArray *_keys;
    NSMutableDictionary *_content;
}
@end


@implementation DrugSearchViewController

@synthesize searchBar = _searchBar;
@synthesize tblResults = _tblResults;
@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    _letters = [NSArray arrayWithObjects:@"SYM", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
                @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U",
                @"V", @"W", @"X", @"Y", @"Z", nil];
    _content = [[NSMutableDictionary alloc] init];
    
    
    CGFloat dX = 0;
    CGFloat dY = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = 40;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    
    dY = self.searchBar.frame.origin.y+self.searchBar.frame.size.height;
    dHeight = self.view.frame.size.height - dY - self.tabBarController.tabBar.frame.size.height;
    frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.tblResults = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tblResults.delegate = self;
    self.tblResults.dataSource = self;
    self.tblResults.scrollEnabled = YES;
    self.tblResults.userInteractionEnabled = YES;
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tblResults];
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                      action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
    self.navigationItem.title = @"Search Drugs";
}

-(void) rightDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _content = nil;
    _keys = nil;
    self.fetchedResultsController = nil;
}

- (void) createSections
{
    [_content removeAllObjects];
    
    NSMutableArray *arrNonAlpha = [[NSMutableArray alloc] init];
    
    for (NSString *letter in _letters)
    {
        NSMutableArray *arrValues = [[NSMutableArray alloc] init];
        
        for (Product *p in [self.fetchedResultsController fetchedObjects])
        {
            NSString *term = [JJJUtil toASCII:p.drugName];
            
            if ([JJJUtil isAlphaStart:term])
            {
                if ([[term uppercaseString] hasPrefix:letter])
                {
                    if (![arrValues containsObject:p])
                    {
                        [arrValues addObject:p];
                    }
                }
            }
            else
            {
                if (![arrNonAlpha containsObject:p])
                {
                    [arrNonAlpha addObject:p];
                }
            }
            
            //                    NSString *name = [dict objectForKey:@"Drug Name"];
            //
            //                    if ([[name uppercaseString] hasPrefix:letter])
            //                    {
            //                        if (![arrValues containsObject:dict])
            //                        {
            //                            [arrValues addObject:dict];
            //                        }
            //                    }
        }
        
        if (arrValues.count > 0)
        {
            [_content setValue:arrValues forKey:letter];
        }
    }
    
    if (arrNonAlpha.count > 0)
    {
        [_content setValue:arrNonAlpha forKey:[_letters objectAtIndex:0]];
    }
    
    _keys =  [[_content allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    NSString *prefix = [_keys objectAtIndex:indexPath.section];
    NSArray *arr = [_content objectForKey:prefix];
    
    Product *p = [arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.drugName;
    cell.detailTextLabel.text = p.activeIngred;
    cell.textLabel.font = kMenuFont;
    cell.detailTextLabel.font = kMenuFont;
}

-(void) search
{
    NSError *error;
    self.fetchedResultsController = [[Database sharedInstance] search:DrugsDataSource
                                                                query:self.searchBar.text
                                                         narrowSearch:YES];
    self.fetchedResultsController.delegate = self;
    
    if (![self.fetchedResultsController performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [self createSections];
    [self.tblResults reloadData];
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
    [text appendFormat:@"%@ (%d of %d)", letter, [[_content valueForKey:letter] count], [[self.fetchedResultsController fetchedObjects] count]];
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
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *prefix = [_keys objectAtIndex:indexPath.section];
    NSArray *arr = [_content objectForKey:prefix];
    
    DrugSummaryViewController *viewController = [[DrugSummaryViewController alloc] init];
    viewController.drugSummary = [arr objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar
{
    if ([self.searchBar canResignFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    [hud showWhileExecuting:@selector(search) onTarget:self withObject:nil animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tblResults beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.tblResults;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tblResults;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = self.tblResults;
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [tableView endUpdates];
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

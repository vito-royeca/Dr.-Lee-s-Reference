//
//  SearchViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/14/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "SearchViewController.h"
#import "JJJ/JJJUtil.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize searchBar = _searchBar;
@synthesize tblResults = _tblResults;
@synthesize fetchedResultsController = _fetchedResultsController;

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
    
    CGFloat dX = 0;
    CGFloat dY = 0;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height;;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.searchBar.delegate = self;
    
    frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.tblResults = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tblResults.delegate = self;
    self.tblResults.dataSource = self;
    self.tblResults.scrollEnabled = YES;
    self.tblResults.userInteractionEnabled = YES;
    
    MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                      action:@selector(rightDrawerButtonPress:)];
    
    if(OSVersionIsAtLeastiOS7())
    {
        UIColor *barColor = [UIColor colorWithRed:247.0/255.0
                                            green:249.0/255.0
                                            blue:250.0/255.0
                                            alpha:1.0];
        [self.navigationController.navigationBar setBarTintColor:barColor];
        [self.tabBarController.tabBar setBarTintColor:barColor];
    }
    else
    {
        UIColor * barColor = [UIColor colorWithRed:78.0/255.0
                                             green:156.0/255.0
                                              blue:206.0/255.0
                                             alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
        [self.tabBarController.tabBar setTintColor:barColor];
    }
    
    
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tblResults];
    
    // remove the "< Back" title in back buttons
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

-(void) rightDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)contentSizeDidChange:(NSString *)size
{
    [self.tblResults reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.fetchedResultsController = nil;
}

#pragma - mark UITableViewDataSource
//- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.keys;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
//{
//    return [self.keys indexOfObject:title];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	return [sectionInfo numberOfObjects];
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//{
//    UILabel *lblHeader = [[UILabel alloc] init];
//    
//    NSMutableString *text = [[NSMutableString alloc] init];
//    NSString *letter = [_keys objectAtIndex:section];
//    [text appendFormat:@"%@ (%d of %d)", letter, [[self.content valueForKey:letter] count], [[self.fetchedResultsController fetchedObjects] count]];
//    lblHeader.text = text;
//    lblHeader.backgroundColor = [UIColor colorWithRed:208.0/255.0
//                                                green:208.0/255.0
//                                                 blue:208.0/255.0
//                                                alpha:1.0];
//    lblHeader.userInteractionEnabled = YES;
//    [lblHeader setTag:section+1];
//    return lblHeader;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    return [self.keys objectAtIndex:section];
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSString *name = [theSection name];
    return name;
//    if ([JJJUtil isAlphaStart:name])
//    {
//        return [name substringToIndex:1];
//    }
//    else
//    {
//        return @"SYM";
//    }
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
//    NSString *prefix = [self.keys objectAtIndex:indexPath.section];
//    NSArray *arr = [self.content objectForKey:prefix];
//    UIViewController *viewController = [self detailViewWithObject:[arr objectAtIndex:indexPath.row]];

    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIViewController *viewController = [self detailViewWithObject:object];
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
    [hud showWhileExecuting:@selector(doSearch) onTarget:self withObject:nil animated:YES];
}

- (void) doSearch
{
    self.fetchedResultsController = nil;
    NSFetchedResultsController *frc = self.fetchedResultsController;
    frc.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
//    [self createSections];
    [self.tblResults reloadData];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tblResults beginUpdates];
    NSLog(@"%d %s %s", __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"%d %s %s", __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    
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
    NSLog(@"%d %s %s", __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    
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
    NSLog(@"%d %s %s", __LINE__, __PRETTY_FUNCTION__, __FUNCTION__);
    
    UITableView *tableView = self.tblResults;
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [tableView endUpdates];
}

#pragma mark - Empty methods to be implemented by subclasses
- (void) createSections
{
    
}

- (void) configureCell:(UITableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIViewController*) detailViewWithObject:(id) object
{
    return nil;
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

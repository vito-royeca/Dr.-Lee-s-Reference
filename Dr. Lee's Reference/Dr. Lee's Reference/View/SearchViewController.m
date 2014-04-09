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
@synthesize fetchedResultsController;
@synthesize dataSource;

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

    
    CGFloat dX = 0;
    CGFloat dY = 0;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    searchBar = [[UISearchBar alloc] initWithFrame:frame];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.delegate = self;
    switch (dataSource)
    {
        case DictionaryDataSource:
        {
            searchBar.placeholder = @"search dictionary";
            break;
        }
        case DrugsDataSource:
        {
            searchBar.placeholder = @"search drugs";
            break;
        }
        case ICD10DataSource:
        {
            searchBar.placeholder = @"search ICD-10";
            break;
        }
    }
    
    dHeight = self.view.frame.size.height + dHeight + [UIApplication sharedApplication].statusBarFrame.size.height;
    frame = CGRectMake(dX, dY, dWidth, dHeight);
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
    
    _content = nil;
    _keys = nil;
    fetchedResultsController = nil;
}

- (void) createSections
{
    [_content removeAllObjects];
    
    NSMutableArray *arrNonAlpha = [[NSMutableArray alloc] init];
    
    for (NSString *letter in _letters)
    {
        NSMutableArray *arrValues = [[NSMutableArray alloc] init];
        
        switch (dataSource)
        {
            case DictionaryDataSource:
            {
                for (DictionaryTerm *d in [fetchedResultsController fetchedObjects])
                {
                    NSString *term = [JJJUtil toASCII:d.term];
                    
                    if ([JJJUtil isAlphaStart:term])
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
                for (Product *p in [fetchedResultsController fetchedObjects])
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

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    NSString *prefix = [_keys objectAtIndex:indexPath.section];
    NSArray *arr = [_content objectForKey:prefix];
    
    switch (dataSource)
    {
        case DictionaryDataSource:
        {
            DictionaryTerm *d = [arr objectAtIndex:indexPath.row];
            DictionaryDefinition *def = d.dictionaryDefinition && d.dictionaryDefinition.count > 0 ? [[d.dictionaryDefinition allObjects] objectAtIndex:0] : nil;
            DictionarySynonym *syn = d.dictionarySynonym && d.dictionarySynonym.count > 0 ? [[d.dictionarySynonym allObjects] objectAtIndex:0] : nil;
            
            cell.textLabel.text = d.term;
//            cell.detailTextLabel.text = def ? def.definition : (syn ? [NSString stringWithFormat:@"SYN %@", syn.term] : @"");
            cell.textLabel.font = kMenuFont;
            cell.detailTextLabel.font = kMenuFont;
            break;
        }
        case DrugsDataSource:
        {
            Product *p = [arr objectAtIndex:indexPath.row];
            
            cell.textLabel.text = p.drugName;
            cell.detailTextLabel.text = p.activeIngred;
            cell.textLabel.font = kMenuFont;
            cell.detailTextLabel.font = kMenuFont;
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
    NSError *error;
    fetchedResultsController = [[Database sharedInstance] search:dataSource
                                                           query:searchBar.text
                                                    narrowSearch:YES];
    fetchedResultsController.delegate = self;

    if (![fetchedResultsController performFetch:&error])
    {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    [self createSections];
    [tblResults reloadData];
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
    [text appendFormat:@"%@ (%d of %d)", letter, [[_content valueForKey:letter] count], [[fetchedResultsController fetchedObjects] count]];
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
    
    switch (dataSource)
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

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar
{
    if ([searchBar canResignFirstResponder])
    {
        [searchBar resignFirstResponder];
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
    [tblResults beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = tblResults;
    
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
    UITableView *tableView = tblResults;
    
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
    UITableView *tableView = tblResults;
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [tableView endUpdates];
}

@end

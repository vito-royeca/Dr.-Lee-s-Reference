//
//  SearchViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionarySearchViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@implementation DictionarySearchViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (super.fetchedResultsController != nil)
    {
        return super.fetchedResultsController;
    }
    
    NSFetchedResultsController *nsfrc = [[Database sharedInstance] search:DictionaryDataSource
                                                                    query:super.searchBar.text
                                                             narrowSearch:NO];
    super.fetchedResultsController = nsfrc;
    super.fetchedResultsController.delegate = self;
    return super.fetchedResultsController;
}

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
    
    super.searchBar.placeholder = @"search dictionary";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
//    NSString *prefix = [super.keys objectAtIndex:indexPath.section];
//    NSArray *arr = [super.content objectForKey:prefix];
//    
//    DictionaryTerm *d = [arr objectAtIndex:indexPath.row];
//    DictionaryDefinition *def = d.dictionaryDefinition && d.dictionaryDefinition.count > 0 ? [[d.dictionaryDefinition allObjects] objectAtIndex:0] : nil;
//    DictionarySynonym *syn = d.dictionarySynonym && d.dictionarySynonym.count > 0 ? [[d.dictionarySynonym allObjects] objectAtIndex:0] : nil;

    DictionaryTerm *d = [super.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = d.term;
//    cell.detailTextLabel.text = def ? def.definition : (syn ? [NSString stringWithFormat:@"SYN %@", syn.term] : @"");
    //    cell.textLabel.font = kMenuFont;
    //    cell.detailTextLabel.font = kMenuFont;
}

- (UIViewController*) detailViewWithObject:(id) object
{
    DictionaryDetailViewController *viewController = [[DictionaryDetailViewController alloc] init];
    viewController.dictionaryTerm = object;
    
    return viewController;
}

@end

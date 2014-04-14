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
    if (!super.fetchedResultsController)
    {
        super.fetchedResultsController = [[Database sharedInstance] search:DictionaryDataSource
                                                                     query:super.searchBar.text
                                                              narrowSearch:NO];
    }
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

//- (void) createSections
//{
//    [super.content removeAllObjects];
//    
//    NSMutableArray *arrNonAlpha = [[NSMutableArray alloc] init];
//    
//    for (NSString *letter in super.letters)
//    {
//        NSMutableArray *arrValues = [[NSMutableArray alloc] init];
//        
//        for (DictionaryTerm *d in [self.fetchedResultsController fetchedObjects])
//        {
//            NSString *term = [JJJUtil toASCII:d.term];
//            
//            if ([JJJUtil isAlphaStart:term])
//            {
//                if ([[term uppercaseString] hasPrefix:letter])
//                {
//                    if (![arrValues containsObject:d])
//                    {
//                        [arrValues addObject:d];
//                    }
//                }
//            }
//            else
//            {
//                if (![arrNonAlpha containsObject:d])
//                {
//                    [arrNonAlpha addObject:d];
//                }
//            }
//        }
//        
//        if (arrValues.count > 0)
//        {
//            [super.content setValue:arrValues forKey:letter];
//        }
//    }
//
//    if (arrNonAlpha.count > 0)
//    {
//        [super.content setValue:arrNonAlpha forKey:[super.letters objectAtIndex:0]];
//    }
//    
//    super.keys =  [[NSMutableArray alloc] initWithArray:[[super.content allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
//    
//    if (arrNonAlpha.count > 0)
//    {
//        [super.content setValue:arrNonAlpha forKey:[super.letters objectAtIndex:0]];
//        [super.keys removeObject:[super.letters objectAtIndex:0]];
//        [super.keys insertObject:[super.letters objectAtIndex:0] atIndex:0];
//    }
//}

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

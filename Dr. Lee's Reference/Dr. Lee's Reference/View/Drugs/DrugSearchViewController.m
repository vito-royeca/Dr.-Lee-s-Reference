//
//  DrugSearchViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/11/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DrugSearchViewController.h"
#import "DrugSummaryViewController.h"
#import "DrugProduct.h"

@implementation DrugSearchViewController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (!super.fetchedResultsController)
    {
        super.fetchedResultsController = [[Database sharedInstance] search:DrugsDataSource
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
    
    super.searchBar.placeholder = @"search drugs";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void) createSections
{
    [super.content removeAllObjects];
    
    NSMutableArray *arrNonAlpha = [[NSMutableArray alloc] init];
    
    for (NSString *letter in super.letters)
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
            [super.content setValue:arrValues forKey:letter];
        }
    }
    
    if (arrNonAlpha.count > 0)
    {
        [super.content setValue:arrNonAlpha forKey:[super.letters objectAtIndex:0]];
    }
    
    super.keys =  [[NSMutableArray alloc] initWithArray:[[super.content allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
    
    if (arrNonAlpha.count > 0)
    {
        [super.content setValue:arrNonAlpha forKey:[super.letters objectAtIndex:0]];
        [super.keys removeObject:[super.letters objectAtIndex:0]];
        [super.keys insertObject:[super.letters objectAtIndex:0] atIndex:0];
    }
}
*/
- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
//    NSString *prefix = [super.keys objectAtIndex:indexPath.section];
//    NSArray *arr = [super.content objectForKey:prefix];
//    
//    Product *p = [arr objectAtIndex:indexPath.row];

    DrugProduct *p = [super.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = p.drugName;
    cell.detailTextLabel.text = p.activeIngred;
}

- (UIViewController*) detailViewWithObject:(id) object
{
    DrugSummaryViewController *viewController = [[DrugSummaryViewController alloc] init];
    viewController.drugSummary = object;
    
    return viewController;
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

//
//  SearchViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/14/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SearchViewController : UIViewController<MBProgressHUDDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) UITableView *tblResults;

@property(strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(strong,nonatomic) NSArray *letters;
@property(strong,nonatomic) NSMutableArray *keys;
@property(strong,nonatomic) NSMutableDictionary *content;

- (void) doSearch;
- (void) createSections;
- (void) configureCell:(UITableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath;
- (UIViewController*) detailViewWithObject:(id) object;

@end

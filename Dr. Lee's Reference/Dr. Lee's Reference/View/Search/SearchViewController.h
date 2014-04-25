//
//  SearchViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/14/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"
#import "MBProgressHUD.h"

@interface SearchViewController : UIViewController<MBProgressHUDDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, IASKSettingsDelegate>

@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) UITableView *tblResults;
@property(strong,nonatomic) IASKAppSettingsViewController *settingsViewController;
@property(strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void) doSearch;
- (void) configureCell:(UITableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath;
- (UIViewController*) detailViewWithObject:(id) object;

@end

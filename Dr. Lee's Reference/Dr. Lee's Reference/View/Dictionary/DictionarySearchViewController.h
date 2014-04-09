//
//  SearchViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Constants.h"

#import "JJJ/JJJ.h"
#import "Database.h"
#import "DictionaryTerm.h"
#import "DictionaryDetailViewContoller.h"
#import "DrugSummaryViewController.h"
#import "MBProgressHUD.h"
#import "Product.h"

@interface DictionarySearchViewController : UIViewController<MBProgressHUDDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) UITableView *tblResults;

@property(strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic) DataSource dataSource;

@end

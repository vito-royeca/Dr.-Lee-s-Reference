//
//  DrugSearchViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/11/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Constants.h"

#import "Database.h"
#import "DictionaryDefinition.h"
#import "DictionaryXRef.h"
#import "MBProgressHUD.h"

@interface DrugSearchViewController : UIViewController<MBProgressHUDDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) UITableView *tblResults;

@property(strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

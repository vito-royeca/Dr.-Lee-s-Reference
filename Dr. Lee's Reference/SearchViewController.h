//
//  SearchViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/26/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Database.h"
#import "MBProgressHUD.h"

@interface SearchViewController : UIViewController<MBProgressHUDDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UISearchBar *searchBar;
@property(strong,nonatomic) UITableView *tblResults;

@property(strong,nonatomic) NSArray *results;

@end

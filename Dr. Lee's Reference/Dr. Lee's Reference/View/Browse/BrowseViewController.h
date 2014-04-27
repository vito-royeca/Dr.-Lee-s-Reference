//
//  BrowseViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) UITableView *tblBrowse;

@end

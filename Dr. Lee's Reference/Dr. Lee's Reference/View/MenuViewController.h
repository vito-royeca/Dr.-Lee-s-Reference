//
//  MenuViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/18/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "Constants.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tblMenu;

@end

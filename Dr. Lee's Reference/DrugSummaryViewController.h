//
//  DrugSummaryViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrugDetailsViewController.h"
#import "Util.h"

@interface DrugSummaryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UITableView *tblDrug;

@property(strong,nonatomic) NSDictionary *drugSummary;

@end

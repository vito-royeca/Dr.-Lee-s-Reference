//
//  DrugDetailsViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Product.h"

@interface DrugDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UITableView *tblDrug;

@property(strong,nonatomic) NSDictionary *drugDetails;

@end

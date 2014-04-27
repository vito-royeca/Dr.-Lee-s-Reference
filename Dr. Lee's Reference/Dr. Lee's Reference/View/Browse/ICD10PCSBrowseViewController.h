//
//  ICD10PCSBrowseViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/27/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"

@interface ICD10PCSBrowseViewController : UIViewController<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) RATreeView *treeView;

@end

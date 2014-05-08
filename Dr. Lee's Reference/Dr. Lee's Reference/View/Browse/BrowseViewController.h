//
//  BrowseViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "RATreeView.h"

@protocol BrowseViewExpander <NSObject>

-(NSArray*) treeStructure:(int) depthLevel;

@end

@interface BrowseViewController : UIViewController<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) id<BrowseViewExpander> delegate;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) RATreeView *treeView;

@end

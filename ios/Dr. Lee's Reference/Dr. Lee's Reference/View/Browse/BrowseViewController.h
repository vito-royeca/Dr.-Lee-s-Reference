//
//  BrowseViewController.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "MBProgressHUD.h"
#import "RADataObject.h"
#import "RATreeView/RATreeView.h"

@protocol BrowseViewExpander <NSObject>

-(NSArray*) initialTreeStructure;
-(NSArray*) treeStructureForItem:(id)item;

@optional
//-(NSString*) infoPathForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo;

@end

@interface BrowseViewController : UIViewController<MBProgressHUDDelegate, RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) id<BrowseViewExpander> delegate;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSString *mainTitle;

- (id)initShowSegmentedControl:(BOOL)showSegmentedControl;

@end

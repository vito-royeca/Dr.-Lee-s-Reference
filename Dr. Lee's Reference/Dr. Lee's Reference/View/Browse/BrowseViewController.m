//
//  BrowseViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "BrowseViewController.h"
#import "JJJ/JJJ.h"
#import "DictionaryBrowseViewExpander.h"
#import "DrugsBrowseViewExpander.h"
#import "ICD10CMBrowseViewExpander.h"
#import "ICD10PCSBrowseViewExpander.h"
#import "InfoViewController.h"
#import "RADataObject.h"

@interface BrowseViewController ()
{
    int _nodeLevel;
    RADataObject *_currectNode;
}
@end

@implementation BrowseViewController

@synthesize data = _data;
@synthesize segmentedControl;
@synthesize treeView = _treeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat dX = 0;
    CGFloat dY = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = 40;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:
                             @[@"Dictionary", @"FDA Drugs", @"ICD10 CM", @"ICD10 PCS"]];
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.scrollEnabled = YES;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.frame = frame;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlChangedValue:)
                    forControlEvents:UIControlEventValueChanged];

    dY += 40;
    dHeight = self.view.frame.size.height - dHeight;
    frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.treeView = [[RATreeView alloc] initWithFrame:frame];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    [self.treeView reloadData];
    [self.treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.treeView];
    self.navigationItem.title = @"Browse";
    
    [self segmentedControlChangedValue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) segmentedControlChangedValue:(id) sender
{
    switch (self.segmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            self.delegate = [[DictionaryBrowseViewExpander alloc] init];
            break;
        }
        case 1:
        {
            self.delegate = [[DrugsBrowseViewExpander alloc] init];
            break;
        }
        case 2:
        {
            self.delegate = [[ICD10CMBrowseViewExpander alloc] init];
            break;
        }
        case 3:
        {
            self.delegate = [[ICD10PCSBrowseViewExpander alloc] init];
            break;
        }
    }
    
    self.data = [self.delegate initialTreeStructure];
    [self.treeView reloadData];
}

#pragma mark - RATreeViewDelegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return treeNodeInfo.treeDepthLevel * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded])
    {
        return YES;
    }
    
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *object = item;
    
    if (treeNodeInfo.treeDepthLevel == 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    }
    else
    {
        if (treeNodeInfo.treeDepthLevel % 2 == 0)
        {
            cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
        }
        else
        {
            cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
        }
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *data = item;
    
    if (!data.children)
    {
        NSArray *children = [self.delegate treeStructureForItem:data treeNodeInfo:treeNodeInfo];

        data.children = children;
        self.expanded = data;

//        for (RADataObject *ra in self.data)
//        {
//            if (ra != node)
//            {
//                ra.children = nil;
//            }
//        }
        [self.treeView reloadData];
    }
}

- (void)treeView:(RATreeView *)treeView accessoryButtonTappedForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([self.delegate respondsToSelector:@selector(detailViewForItem:treeNodeInfo:)])
    {
        UIViewController *detailView = [self.delegate detailViewForItem:item treeNodeInfo:treeNodeInfo];
        
        if (detailView)
        {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailView];
            [self.navigationController presentViewController:navController animated:NO completion:nil];
        }
    }
}

#pragma mark - RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([self.delegate respondsToSelector:@selector(cellForItem:treeNodeInfo:)])
    {
        return [self.delegate cellForItem:item treeNodeInfo:treeNodeInfo];
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.text = ((RADataObject *)item).name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        return cell;
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil)
    {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    
    if (item == nil)
    {
        return [self.data objectAtIndex:index];
    }
    
    return [data.children objectAtIndex:index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

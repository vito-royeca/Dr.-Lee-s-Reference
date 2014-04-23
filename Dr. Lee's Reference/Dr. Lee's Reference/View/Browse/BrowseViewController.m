//
//  BrowseViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/23/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "BrowseViewController.h"
#import "RADataObject.h"

@interface BrowseViewController ()

@end

@implementation BrowseViewController

@synthesize data = _data;
@synthesize expanded = _expanded;
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
    
    RADataObject *dictionary = [RADataObject dataObjectWithName:@"Dictionary" children:[self raObjectAlphabets]];
    
    RADataObject *drugs = [RADataObject dataObjectWithName:@"FDA Drugs" children:
                           @[[RADataObject dataObjectWithName:@"Alphabetical" children:[self raObjectAlphabets]],
                             [RADataObject dataObjectWithName:@"Company" children:[self raObjectAlphabets]]]];
    
    RADataObject *icd10CM = [RADataObject dataObjectWithName:@"ICD10 CM" children:
                             @[[RADataObject dataObjectWithName:@"Tabular" children:nil],
                               [RADataObject dataObjectWithName:@"Neoplasm" children:nil],
                               [RADataObject dataObjectWithName:@"Drugs" children:nil],
                               [RADataObject dataObjectWithName:@"Index" children:nil],
                               [RADataObject dataObjectWithName:@"Extended Index" children:nil]]];
    
    RADataObject *icd10PCS = [RADataObject dataObjectWithName:@"ICD10 PCS" children:
                              @[[RADataObject dataObjectWithName:@"Tabular" children:nil],
                                [RADataObject dataObjectWithName:@"Index" children:nil],
                                [RADataObject dataObjectWithName:@"Definitions" children:nil]]];
    
    self.data = @[dictionary, drugs, icd10CM, icd10PCS];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
//    [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
//    [treeView setBackgroundColor:[UIColor cyanColor]];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
}

- (NSArray*) raObjectAlphabets
{
    return @[[RADataObject dataObjectWithName:@"#" children:nil],
             [RADataObject dataObjectWithName:@"A" children:nil],
             [RADataObject dataObjectWithName:@"B" children:nil],
             [RADataObject dataObjectWithName:@"C" children:nil],
             [RADataObject dataObjectWithName:@"D" children:nil],
             [RADataObject dataObjectWithName:@"E" children:nil],
             [RADataObject dataObjectWithName:@"F" children:nil],
             [RADataObject dataObjectWithName:@"G" children:nil],
             [RADataObject dataObjectWithName:@"H" children:nil],
             [RADataObject dataObjectWithName:@"I" children:nil],
             [RADataObject dataObjectWithName:@"J" children:nil],
             [RADataObject dataObjectWithName:@"K" children:nil],
             [RADataObject dataObjectWithName:@"L" children:nil],
             [RADataObject dataObjectWithName:@"M" children:nil],
             [RADataObject dataObjectWithName:@"N" children:nil],
             [RADataObject dataObjectWithName:@"O" children:nil],
             [RADataObject dataObjectWithName:@"P" children:nil],
             [RADataObject dataObjectWithName:@"Q" children:nil],
             [RADataObject dataObjectWithName:@"R" children:nil],
             [RADataObject dataObjectWithName:@"S" children:nil],
             [RADataObject dataObjectWithName:@"T" children:nil],
             [RADataObject dataObjectWithName:@"U" children:nil],
             [RADataObject dataObjectWithName:@"V" children:nil],
             [RADataObject dataObjectWithName:@"W" children:nil],
             [RADataObject dataObjectWithName:@"X" children:nil],
             [RADataObject dataObjectWithName:@"Y" children:nil],
             [RADataObject dataObjectWithName:@"Z" children:nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RATreeViewDelegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
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
//    if (treeNodeInfo.treeDepthLevel == 0)
//    {
//        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
//    }
//    else if (treeNodeInfo.treeDepthLevel == 1)
//    {
//        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
//    }
//    else if (treeNodeInfo.treeDepthLevel == 2)
//    {
//        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
//    }
}

#pragma mark - RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of children %@", [@(numberOfChildren) stringValue]];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (treeNodeInfo.treeDepthLevel == 0)
    {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
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

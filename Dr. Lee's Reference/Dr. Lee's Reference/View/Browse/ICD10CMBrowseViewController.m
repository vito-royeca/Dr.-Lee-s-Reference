//
//  ICD10CMBrowseViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/27/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMBrowseViewController.h"
#import "RADataObject.h"

@interface ICD10CMBrowseViewController ()

@end

@implementation ICD10CMBrowseViewController

@synthesize treeView = _treeView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.data = @[[RADataObject dataObjectWithName:@"Tabular" children:nil],
                      [RADataObject dataObjectWithName:@"Neoplasm" children:nil],
                      [RADataObject dataObjectWithName:@"Drugs" children:nil],
                      [RADataObject dataObjectWithName:@"Index" children:nil],
                      [RADataObject dataObjectWithName:@"Extended Index" children:nil]];
        
        self.treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
        
        self.treeView.delegate = self;
        self.treeView.dataSource = self;
        self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
        
        [self.treeView reloadData];
        //    [self.treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
        //    [self.treeView setBackgroundColor:[UIColor cyanColor]];
        
        UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showInfo:)];
        
        [self.navigationItem setRightBarButtonItem:btnSettings animated:YES];
        self.navigationItem.title = @"ICD10 CM";
        [self.view addSubview:self.treeView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showInfo:(id) sender
{
    
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
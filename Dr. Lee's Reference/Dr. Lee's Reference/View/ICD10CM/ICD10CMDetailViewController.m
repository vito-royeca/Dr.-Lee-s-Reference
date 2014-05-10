//
//  ICD10CMDetailViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/9/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMDetailViewController.h"
#import "JJJ/JJJ.h"

@interface ICD10CMDetailViewController ()

@end

@implementation ICD10CMDetailViewController

@synthesize diagnosis = _diagnosis;
@synthesize data = _data;
@synthesize tblData = _tblData;

-(id) initWithDiagnosis:(ICD10Diagnosis*) diagnosis
{
    self.diagnosis = diagnosis;
    
    return [self initWithNibName:nil bundle:nil];
}

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
    self.data = [[NSMutableArray alloc] init];
    
    [self.data addObject:@{@"Code": @[self.diagnosis.name]}];
    [self.data addObject:@{@"Description": @[self.diagnosis.desc]}];
     
    if (self.diagnosis.inclusionTerm)
    {
        [self.data addObject:@{@"Inclusion Terms" : [self.diagnosis.inclusionTerm componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.includes)
    {
        [self.data addObject:@{@"Includes" : [self.diagnosis.includes componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.excludes)
    {
        [self.data addObject:@{@"Excludes" : [self.diagnosis.excludes componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.useAdditionalCode)
    {
        [self.data addObject:@{@"Use Additional Code" : [self.diagnosis.useAdditionalCode componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.excludes1)
    {
        [self.data addObject:@{@"Excludes 1" : [self.diagnosis.excludes1 componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.excludes2)
    {
        [self.data addObject:@{@"Excludes 2" : [self.diagnosis.excludes2 componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.codeFirst)
    {
        [self.data addObject:@{@"Code First" : [self.diagnosis.codeFirst componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    if (self.diagnosis.codeAlso)
    {
        [self.data addObject:@{@"Code Also" : [self.diagnosis.codeAlso componentsSeparatedByString:COMPOUND_SEPARATOR]}];
    }
    
    CGFloat dX = 0;
    CGFloat dY = 0;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.tblData = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tblData.dataSource = self;
    self.tblData.delegate = self;
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(closeDetail:)];
    
    [self.navigationItem setRightBarButtonItem:btnClose];
    [self.view addSubview:self.tblData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) closeDetail:(id) sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.data objectAtIndex:section];
//    NSArray *arr = [dict objectForKey:[[dict allKeys] firstObject]];
//    return arr.count;
    return [dict allValues].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [self.data objectAtIndex:section];
    return [[dict allKeys] firstObject];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [self.data objectAtIndex:indexPath.section];
    NSArray *arr = [dict allValues];
    NSLog(@"%@", [arr objectAtIndex:indexPath.row]);
    cell.textLabel.text = @"high";[arr objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

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

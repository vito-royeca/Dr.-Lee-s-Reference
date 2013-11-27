//
//  DrugDetailsViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DrugDetailsViewController.h"

@interface DrugDetailsViewController ()

@property(strong,nonatomic) NSArray *sections;

@end

@implementation DrugDetailsViewController

@synthesize sections;
@synthesize tblDrug;
@synthesize drugDetails;
@synthesize documents;

- (void) setDrugDetails:(NSDictionary *)drugDetails_
{
    drugDetails = drugDetails_;
    
    sections = [NSArray arrayWithObjects:@"Drug Details",
            [NSString stringWithFormat:@"Products on Application %@", [drugDetails objectForKey:@"ApplNo"]],
                @"Documents", nil];
    
    NSArray *arrDrugs = [drugDetails objectForKey:@"Drugs"];
    Product *p = [arrDrugs objectAtIndex:0];
    NSMutableDictionary *dicSorter = [[NSMutableDictionary alloc] init];
    [dicSorter  setObject:[NSNumber numberWithBool:NO] forKey:@"docDate"];
    documents = [[Database sharedInstance] find:@"AppDoc"
                                     columnName:@"applNo.applNo"
                                    columnValue:p.applNo.applNo
                               relationshipKeys:[NSArray arrayWithObjects:@"applNo", nil]
                                        sorters:[NSArray arrayWithObjects:dicSorter, nil]];
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
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height);
    tblDrug = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tblDrug.delegate = self;
    tblDrug.dataSource = self;
    [self.view addSubview:tblDrug];
    
    [self setTitle:@"Details"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABleViewDataSource
//- (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return sections;
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return [sections indexOfObject:title];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    switch (section)
    {
        case 0:
        {
            rows = 5;
            break;
        }
        case 1:
        {
            rows = [[drugDetails objectForKey:@"Drugs"] count];
            break;
        }
        case 2:
        {
            rows = documents.count;
            break;
        }
    }
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sections objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = @"Drug Name";
                    cell.detailTextLabel.text = [drugDetails objectForKey:@"Drug Name"];
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"FDA Application No.";
                    cell.detailTextLabel.text = [drugDetails objectForKey:@"ApplNo"];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"Active Ingredient(s)";
                    cell.detailTextLabel.text = [drugDetails objectForKey:@"Active Ingredient(s)"];
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"Company";
                    cell.detailTextLabel.text = [drugDetails objectForKey:@"Company"];
                    break;
                }
                case 4:
                {
                    cell.textLabel.text = @"Approval Date";
                    cell.detailTextLabel.text = @"";
                    break;
                }
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case 1:
        {
            NSArray *arrDrugs = [drugDetails objectForKey:@"Drugs"];
            Product *p = [arrDrugs objectAtIndex:indexPath.row];
            
            cell.textLabel.text = p.dosage;
            cell.detailTextLabel.text = [p productMktStatusString];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case 2:
        {
            AppDoc *appDoc = [documents objectAtIndex:indexPath.row];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            
            cell.textLabel.text = appDoc.docType.appDocType;
            cell.detailTextLabel.text = appDoc.docDate ? [formatter stringFromDate:appDoc.docDate] : @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
    }
    
    return cell;
}

@end

//
//  MenuViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/18/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize tblMenu;

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
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tblMenu = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tblMenu.dataSource = self;
    tblMenu.delegate = self;
    [self.view addSubview:tblMenu];
    
    self.view.backgroundColor = kMenuBackgroundColor;
    tblMenu.backgroundColor = kTableBackgroundColor;
    tblMenu.separatorColor = kTableSeparatorColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = kMenuFontColor;
	}
	
	if (row == 0)
	{
		cell.textLabel.text = @"Dr. Lee's Reference";
	}
    else if (row == 1)
	{
		cell.textLabel.text = @"Search";
        cell.textLabel.font = kMenuFont;
	}
	else if (row == 2)
	{
		cell.textLabel.text = @"Browse";
        cell.textLabel.font = kMenuFont;
	}
	else if (row == 3)
	{
		cell.textLabel.text = @"Favorites";
        cell.textLabel.font = kMenuFont;
	}
	else if (row == 4)
	{
		cell.textLabel.text = @"History";
        cell.textLabel.font = kMenuFont;
	}
	else if (row == 5)
	{
		cell.textLabel.text = @"Settings";
        cell.textLabel.font = kMenuFont;
	}
    else if (row == 6)
	{
		cell.textLabel.text = @"About";
        cell.textLabel.font = kMenuFont;
	}
    
	return cell;
}

@end

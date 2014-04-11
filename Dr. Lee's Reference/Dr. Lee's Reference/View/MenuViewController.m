//
//  MenuViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/18/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DictionaryViewController.h"
#import "DrugViewController.h"

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
    tblMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
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
		cell.textLabel.text = kAppTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
	}
    else if (row == 1)
	{
		cell.textLabel.text = kDictionaryTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"literature.png"];
	}
	else if (row == 2)
	{
		cell.textLabel.text = kDrugsTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"pill.png"];
	}
    else if (row == 3)
	{
		cell.textLabel.text = kICD10Title;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"brick.png"];
	}
	else if (row == 4)
	{
		cell.textLabel.text = kFavoritesTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"star.png"];
	}
	else if (row == 5)
	{
		cell.textLabel.text = kHistoryTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"safari.png"];
	}
	else if (row == 6)
	{
		cell.textLabel.text = kSettingsTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"settings.png"];
	}
    else if (row == 7)
	{
		cell.textLabel.text = kAboutTitle;
        cell.textLabel.font = kMenuFont;
        cell.imageView.image = [UIImage imageNamed:@"info.png"];
	}
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UIViewController *viewController;
    
    switch (row)
    {
        case 1:
        {
            viewController = [[DictionaryViewController alloc] init];
            break;
        }
        case 2:
        {
            viewController = [[DrugViewController alloc] init];
            break;
        }
        case 3:
        {
            break;
        }
        case 4:
        {
            break;
        }
    }
    
    if (viewController)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        [appDelegate.drawerController setCenterViewController:viewController];
        [appDelegate.drawerController closeDrawerAnimated:YES completion:nil];
    }
    
}

@end

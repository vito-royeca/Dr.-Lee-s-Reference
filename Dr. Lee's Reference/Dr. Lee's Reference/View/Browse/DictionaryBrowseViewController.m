//
//  DictionaryBrowseViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/27/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DictionaryBrowseViewController.h"

@interface DictionaryBrowseViewController ()

@end

@implementation DictionaryBrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        UIBarButtonItem *btnSettings = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(showInfo:)];
        
        [self.navigationItem setRightBarButtonItem:btnSettings animated:YES];
        self.navigationItem.title = @"Dicitonary";
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

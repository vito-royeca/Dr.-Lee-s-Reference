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
@synthesize webView = _webView;

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
    
    CGFloat dX = 0;
    CGFloat dY = 0;
    CGFloat dWidth = self.view.frame.size.width;
    CGFloat dHeight = self.view.frame.size.height;
    CGRect frame = CGRectMake(dX, dY, dWidth, dHeight);
    self.webView = [[UIWebView alloc] initWithFrame:frame];
    self.webView.delegate = self;
    
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:[self composeHTML] baseURL:bundleUrl];
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(closeDetail:)];
    
    [self.navigationItem setRightBarButtonItem:btnClose];
    [self.view addSubview:self.webView];
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

- (NSString*) composeHTML
{
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendFormat:@"<html><head><style type='text/css'> body {font-family:verdana;} </style> </head>"];
    [html appendFormat:@"<body"];
    
    [html appendFormat:@"<p><font color='blue'><strong>%@</strong></font>", self.diagnosis.name];
    [html appendFormat:@"<p>%@", self.diagnosis.desc];
    
    
    if (self.diagnosis.inclusionTerm)
    {
        [html appendFormat:@"<p><strong>Inclusion Terms</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.inclusionTerm componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.includes)
    {
        [html appendFormat:@"<p><strong>Includes</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.includes componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.excludes)
    {
        [html appendFormat:@"<p><strong>Excludes</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.excludes componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.useAdditionalCode)
    {
        [html appendFormat:@"<p><strong>Use Additional Code</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.useAdditionalCode componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.excludes1)
    {
        [html appendFormat:@"<p><strong>Excludes 1</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.excludes1 componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }

    if (self.diagnosis.excludes2)
    {
        [html appendFormat:@"<p><strong>Excludes 2</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.excludes2 componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.codeFirst)
    {
        [html appendFormat:@"<p><strong>Code First</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.codeFirst componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (self.diagnosis.codeAlso)
    {
        [html appendFormat:@"<p><strong>Code Also</strong>"];
        [html appendFormat:@"<ul>"];
        for (NSString *x in [self.diagnosis.codeAlso componentsSeparatedByString:COMPOUND_SEPARATOR])
        {
            [html appendFormat:@"<li>%@</li>", x];
        }
        [html appendFormat:@"</ul>"];
    }
    
    [html appendFormat:@"</body></html>"];
    
    return html;
}

#pragma mark UITableViewDataSource


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

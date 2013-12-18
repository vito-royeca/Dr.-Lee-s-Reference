//
//  DictionaryTermViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryTermViewController.h"

@interface DictionaryTermViewController ()

@end

@implementation DictionaryTermViewController
{
    NSMutableString *html;
}

@synthesize webView;
@synthesize dictionaryTerm;

- (void) setDictionaryTerm:(DictionaryTerm *)dictionaryTerm_
{
    dictionaryTerm = dictionaryTerm_;
    html = [[NSMutableString alloc] init];
    
    [html appendFormat:@"<html><head><style type='text/css'> body {font-family:verdana;} </style> </head>"];
    [html appendFormat:@"<body"];
    
    [html appendFormat:@"<p><font color='blue'><strong>%@</strong></font>", dictionaryTerm.term];
    if (dictionaryTerm.pronunciation)
    {
        [html appendFormat:@"<br>(<font color='red'>%@</font>)", dictionaryTerm.pronunciation];
    }
    
    if (dictionaryTerm.dictionaryDefinition.count > 0)
    {
        [html appendFormat:@"<p><ul>"];
        for (DictionaryDefinition *def in dictionaryTerm.dictionaryDefinition)
        {
            [html appendFormat:@"<li>%@</li>", def.definition];
        }
        [html appendFormat:@"</ul>"];
    }
    
    if (dictionaryTerm.dictionaryXRef.count > 0)
    {
        [html appendFormat:@"<p>SEE ALSO "];
        int sentinel = 0;
        for (DictionaryXRef *ref in dictionaryTerm.dictionaryXRef)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", ref.term, ref.term, sentinel<dictionaryTerm.dictionaryXRef.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    if (dictionaryTerm.dictionarySynonym.count > 0)
    {
        [html appendFormat:@"<p>SYN "];
        int sentinel = 0;
        for (DictionarySynonym *syn in dictionaryTerm.dictionarySynonym)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", syn.term, syn.term, sentinel<dictionaryTerm.dictionarySynonym.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    [html appendFormat:@"</body></html>"];
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
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [webView loadHTMLString:html baseURL:bundleUrl];
    
    UIBarButtonItem *btnAddFavorite = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(addToFavorite)];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                    target:self
                                                                                    action:@selector(share)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:btnShare, btnAddFavorite, nil];
}

- (void) addToFavorite
{
    
}

- (void) share
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *url = [[request URL] absoluteString];
    
    return NO;
}

@end

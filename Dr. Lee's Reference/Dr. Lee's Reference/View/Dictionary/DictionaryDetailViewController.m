//
//  DictionaryTermViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryDetailViewController.h"
#import "JJJ/JJJ.h"

@interface DictionaryDetailViewController ()

@end

@implementation DictionaryDetailViewController
{
    NSString *_currentTerm;
    NSMutableArray *_history;
    NSString *_backButton;
}

@synthesize webView = _webView;
@synthesize dictionaryTerm = _dictionaryTerm;
@synthesize searchTerm = _searchTerm;

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
    
    _history = [[NSMutableArray alloc] init];
    _backButton = @"<p><a href='#back__'>Back</a>";
    

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:[self composeHTMLDefinition] baseURL:bundleUrl];
    
//    UIBarButtonItem *btnAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
//                                                                               target:self
//                                                                               action:@selector(doAction)];
//
//    self.navigationItem.rightBarButtonItem = btnAction;
    [self.view addSubview:self.webView];
}

- (void) doAction
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*) composeHTMLDefinition
{
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendFormat:@"<html><head><style type='text/css'> body {font-family:verdana;} </style> </head>"];
    [html appendFormat:@"<body"];
    
    NSString *term = self.dictionaryTerm.term;
    if (self.searchTerm && self.searchTerm.length>1)
    {
        term = [term stringByReplacingOccurrencesOfString:self.searchTerm withString:[NSString stringWithFormat:@"<mark>%@</mark>", self.searchTerm]];
    }
    [html appendFormat:@"<p><font color='blue'><strong>%@</strong></font>", term];
    
    
    if (self.dictionaryTerm.pronunciation)
    {
        [html appendFormat:@"<br>(<font color='red'>%@</font>)", self.dictionaryTerm.pronunciation];
    }
    else
    {
        [html appendFormat:@"<br>&nbsp;"];
    }
    
    if (self.dictionaryTerm.definition)
    {
        NSMutableArray *defs = [[NSMutableArray alloc] init];
        
        for (NSString *def in [NSMutableArray arrayWithArray:[self.dictionaryTerm.definition componentsSeparatedByString:COMPOUND_SEPARATOR]])
        {
            if (self.searchTerm && self.searchTerm.length>1)
            {
                NSString *defReplacement = [def stringByReplacingOccurrencesOfString:self.searchTerm withString:[NSString stringWithFormat:@"<mark>%@</mark>", self.searchTerm]];
                
                [defs addObject:defReplacement];
            }
            else
            {
                [defs addObject:def];
            }
        }
        
        if (defs.count == 1)
        {
            [html appendFormat:@"<p>%@",  [defs objectAtIndex:0]];
        }
        else
        {
            [html appendFormat:@"<p><ol>"];
            for (NSString *def in defs)
            {
                [html appendFormat:@"<li>%@</li>", def];
            }
            [html appendFormat:@"</ol>"];
        }
    }
    
    if (self.dictionaryTerm.xref.count > 0)
    {
        [html appendFormat:@"<p>SEE ALSO "];
        int sentinel = 0;
        for (DictionaryXRef *ref in self.dictionaryTerm.xref)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", ref.xref, ref.xref, sentinel<self.dictionaryTerm.xref.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    if (self.dictionaryTerm.synonym.count > 0)
    {
        [html appendFormat:@"<p>SYN "];
        int sentinel = 0;
        for (DictionarySynonym *syn in self.dictionaryTerm.synonym)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", syn.synonym, syn.synonym, sentinel<self.dictionaryTerm.synonym.count-1?@", ":@""];
            sentinel++;
        }
    }
    [html appendFormat:@"</body></html>"];

//    if (_previousHTML && ![_previousHTML isEqualToString:html])
    if (_history.count > 0)
    {
        if (![[_history objectAtIndex:_history.count-1] isEqualToString:self.dictionaryTerm.term])
        {
            [html insertString:_backButton atIndex:html.length-14];
        }
    }
    return html;
}

- (NSString*) composeHTMLList:(NSString*)term withResults:(NSArray*)results
{
    NSMutableString *html = [[NSMutableString alloc] init];
    
    [html appendFormat:@"<html><head><style type='text/css'> body {font-family:verdana;} </style> </head>"];
    [html appendFormat:@"<body"];
    
    [html appendFormat:@"<p><font color='blue'><strong>%@</strong></font>", term];
    

    [html appendFormat:@"<p><ul>"];
    for (DictionaryTerm *dict in results)
    {
        [html appendFormat:@"<li><a href='#%@'>%@</a></li>", dict.term, dict.term];
    }
    [html appendFormat:@"</ul>"];
    [html appendFormat:@"</body></html>"];

//    if (_previousHTML && ![_previousHTML isEqualToString:html])
    if (_history.count > 0)
    {
        if (![[_history objectAtIndex:_history.count-1] isEqualToString:self.dictionaryTerm.term])
        {
            [html insertString:_backButton atIndex:html.length-14];
        }
    }
    return html;
}

#pragma mark - UIWebViewDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSString *fragment = [[url fragment] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        
        if ([fragment isEqualToString:@"back__"])
        {
            if (_history.count > 0)
            {
                [self.webView loadHTMLString:[_history objectAtIndex:_history.count-1]  baseURL:bundleUrl];
                return YES;
            }
        }
        else
        {
/*            NSArray *results = [[Database sharedInstance] search:DictionaryDataSource
                                                           query:fragment
                                                    narrowSearch:YES];

            if (_history.count > 0)
            {
                
            }
//            _previousHTML = _currentHTML;
//            if (_previousHTML)
//            {
//                _previousHTML = [_previousHTML stringByReplacingOccurrencesOfString:_backButton withString:@""];
//            }
            
            if (results.count == 1)
            {
                dictionaryTerm = [results objectAtIndex:0];
                [self.webView loadHTMLString:[self composeHTMLDefinition] baseURL:bundleUrl];
                return YES;
            }
            else
            {
                [self.webView loadHTMLString:[self composeHTMLList:fragment withResults:results] baseURL:bundleUrl];
                return YES;
            }*/
        }
        return NO;
    }
    
    return YES;
}

@end

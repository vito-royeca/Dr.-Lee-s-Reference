//
//  DictionaryTermViewController.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryDetailViewController.h"
#import "JJJ/JJJ.h"
#import <AVFoundation/AVFoundation.h>

@interface DictionaryDetailViewController ()

@end

@implementation DictionaryDetailViewController
{
    NSString *_currentTerm;
    NSMutableArray *_backHistory;
    NSString *_backButton;
    NSString *_playButton;
    AVSpeechSynthesizer *_synthesizer;
    AVSpeechUtterance *_utterance;
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"back" ofType:@"png"];
    _backHistory    = [[NSMutableArray alloc] init];
    _backButton     = [NSString stringWithFormat:@"<a href='#back__'><img src=\"file://%@\" border=\"0\"></a>", path];
    
    path = [[NSBundle mainBundle] pathForResource:@"high_volume" ofType:@"png"];
    _playButton     = [NSString stringWithFormat:@"<a href='#play__'><img src=\"file://%@\" border=\"0\"></a>", path];
    _synthesizer = [[AVSpeechSynthesizer alloc]init];
    
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    
    [html appendFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"file://%@\"></head>", path];
    [html appendFormat:@"<body"];
    
    NSString *term = self.dictionaryTerm.term;
    if (self.searchTerm && self.searchTerm.length>1)
    {
        term = [JJJUtil highlightTerm:term withQuery:self.searchTerm];
        
    }
    [html appendFormat:@"<p><div class='term'>%@</div>", term];
    
    
    if (self.dictionaryTerm.pronunciation)
    {
        [html appendFormat:@"<br>(<div class='pron'>%@</div>)&nbsp;%@", self.dictionaryTerm.pronunciation, _playButton];
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
                [defs addObject:[JJJUtil highlightTerm:def withQuery:self.searchTerm]];
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
        [html appendFormat:@"<p><div class=\"see\">SEE ALSO</div> "];
        int sentinel = 0;
        for (DictionaryXRef *xref in self.dictionaryTerm.xref)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", xref.xref, [JJJUtil highlightTerm:xref.xref withQuery:self.searchTerm], sentinel<self.dictionaryTerm.xref.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    if (self.dictionaryTerm.synonym.count > 0)
    {
        [html appendFormat:@"<p><div class=\"syn\">SYN</div> "];
        int sentinel = 0;
        for (DictionarySynonym *syn in self.dictionaryTerm.synonym)
        {
            [html appendFormat:@"<a href='#%@'>%@</a>%@", syn.synonym, [JJJUtil highlightTerm:syn.synonym withQuery:self.searchTerm], sentinel<self.dictionaryTerm.synonym.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    [html appendFormat:@"<p align='center'>%@&nbsp;&nbsp;", (_backHistory.count > 0 ? _backButton : @"")];
    [html appendFormat:@"</body></html>"];

    return html;
}

- (NSString*) composeHTMLList:(NSArray*) list fromQuery:(NSString*) query
{
    NSMutableString *html = [[NSMutableString alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"];
    
    [html appendFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"file://%@\"></head>", path];
    [html appendFormat:@"<body"];
    
    [html appendFormat:@"<p><ul>"];
    for (DictionaryTerm *dt in list)
    {
        [html appendFormat:@"<li><a href='#%@&type=list'>%@</a></li>", dt.term, [JJJUtil highlightTerm:dt.term withQuery:query]];
    }
    [html appendFormat:@"</ul>"];
    
    [html appendFormat:@"<p align='center'>%@&nbsp;&nbsp;", (_backHistory.count > 0 ? _backButton : @"")];
    [html appendFormat:@"</body></html>"];
    
    return html;
}

#pragma mark - UIWebViewDelegate
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSURL *url = [request URL];
    NSString *fragment = [[url fragment] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *params = [fragment componentsSeparatedByString:@"&"];
    NSString *query = [params firstObject];
    
    NSString *currentPage = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    if ([query isEqualToString:@"play__"])
    {
        if (!_synthesizer.speaking)
        {
            _utterance = [AVSpeechUtterance speechUtteranceWithString:_dictionaryTerm.term];
            _utterance.rate = 0.1f;
            [_synthesizer speakUtterance:_utterance];
        }
        
        [self.webView loadHTMLString:currentPage baseURL:bundleUrl];
        return NO;
    }
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        if ([query isEqualToString:@"back__"])
        {
            NSString *previous = [_backHistory lastObject];
            
            [_backHistory removeObject:previous];
            [self.webView loadHTMLString:previous baseURL:bundleUrl];
        }
        else
        {
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.delegate = self;
            __block NSString *html;
            
            
            [_backHistory addObject:currentPage];
            
            [hud showAnimated:YES whileExecutingBlock:
            ^{
                NSString *type = params.count > 1 ? [params objectAtIndex:1] : nil;
                NSArray *terms;
                
                if (type)
                {
                    terms = [DictionaryTerm MR_findByAttribute:@"term" withValue:query];
                }
                else
                {
                    NSFetchedResultsController *nsfrc = [[Database sharedInstance] search:DictionaryDataSource
                                                                                    query:query
                                                                             narrowSearch:NO];
                    if ([nsfrc performFetch:nil])
                    {
                        terms = [nsfrc fetchedObjects];
                    }
                }
                
                if (terms.count == 1)
                {
                    self.dictionaryTerm = [terms firstObject];
                    self.searchTerm = self.dictionaryTerm.term;
                    html = [self composeHTMLDefinition];
                }
                else
                {
                    html = [self composeHTMLList:terms fromQuery:fragment];
                }
            }
            completionBlock:
            ^{
                [self.webView loadHTMLString:html baseURL:bundleUrl];
            }];
        }
    }
    
    return YES;
}

#pragma mark - MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
	[hud removeFromSuperview];
}

@end

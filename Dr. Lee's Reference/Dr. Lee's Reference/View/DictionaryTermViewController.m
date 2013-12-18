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
    
    [html appendFormat:@"<head><style type='text/css'> body {font-family:verdana;} </style> </head>"];
    [html appendFormat:@"<body"];
    
    [html appendFormat:@"<h1>%@</h1>", dictionaryTerm.term];
    if (dictionaryTerm.pronunciation)
    {
        [html appendFormat:@"<p><h3>Pronunciation</h3>"];
        [html appendFormat:@"<p>%@", dictionaryTerm.pronunciation];
    }
    
    if (dictionaryTerm.dictionaryDefinition.count > 0)
    {
        [html appendFormat:@"<p><h3>Definitions:</h3>"];
        [html appendFormat:@"<ol>"];
        for (DictionaryDefinition *def in dictionaryTerm.dictionaryDefinition)
        {
            [html appendFormat:@"<li>%@</li>", def.definition];
        }
        [html appendFormat:@"</ol>"];
    }
    
    if (dictionaryTerm.dictionarySynonym.count > 0)
    {
        [html appendFormat:@"<p><h3>Synonyms:</h3>"];
        int sentinel = 0;
        for (DictionarySynonym *syn in dictionaryTerm.dictionarySynonym)
        {
            [html appendFormat:@"%@%@", syn.term, sentinel<dictionaryTerm.dictionarySynonym.count-1?@", ":@""];
            sentinel++;
        }
    }
    
    if (dictionaryTerm.dictionaryXRef.count > 0)
    {
        [html appendFormat:@"<p><h3>See:</h3>"];
        int sentinel = 0;
        for (DictionaryXRef *ref in dictionaryTerm.dictionaryXRef)
        {
            [html appendFormat:@"%@%@", ref.term, sentinel<dictionaryTerm.dictionaryXRef.count-1?@", ":@""];
            sentinel++;
        }
    }
    [html appendFormat:@"</body>"];
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
    [self.view addSubview:webView];
    
    NSURL *bundleUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [webView loadHTMLString:html baseURL:bundleUrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

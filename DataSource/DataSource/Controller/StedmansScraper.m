//
//  StedmansScraper.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "StedmansScraper.h"
#import "JJJ/JJJ.h"
#import "DictionaryDefinition.h"
#import "DictionarySynonym.h"
#import "DictionaryTerm.h"
#import "DictionaryXRef.h"
#import "TFHpple.h"

@implementation StedmansScraper
{
    NSArray *_letters;
    int _total;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        _letters = [NSArray arrayWithObjects:
                    @"9",
//                    @"a",
//                    @"b",
//                    @"c",
//                    @"d",
//                    @"e",
//                    @"f",
//                    @"g",
//                    @"h",
//                    @"i",
//                    @"j",
//                    @"k",
//                    @"l",
//                    @"m",
//                    @"n",
//                    @"o",
//                    @"p",
//                    @"q",
//                    @"r",
//                    @"s",
//                    @"t",
//                    @"u",
//                    @"v",
//                    @"w",
//                    @"x",
//                    @"y",
//                    @"z",
                    nil];
    }
    
    return self;
}

-(void) scrape
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"database.sqlite"];
    
    NSDate *dateStart = [NSDate date];
    NSMutableDictionary *dictTotals = [[NSMutableDictionary alloc] init];
        
    // #1 scrape each letter
    for (NSString *letter in _letters)
    {
        // #2 scrape terms in the 1st page letter
        TFHpple *parser = [self scrapePageTerms:[NSString stringWithFormat:@"?l=%@", letter]];

        // #3 scrape terms in the subsections of the letter
        for (NSString *sub in [self subsectionsByLetter:parser])
        {
            [self scrapePageTerms:[NSString stringWithFormat:@"%@", sub]];
        }
            
        [dictTotals setObject:[NSNumber numberWithInt:_total] forKey:letter];
        _total = 0;
    }
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
    NSLog(@"Total: %@", dictTotals);
}

-(TFHpple*) scrapePageTerms:(NSString*)pageParams
{
    TFHpple *parser = [self parsePage:pageParams];
    
    for (NSMutableDictionary *dict in [self parseTerms:parser])
    {
        if (![self isTermInDatabase:[dict objectForKey:@"term"]])
        {
            [self parseDefinition:dict];
            NSLog(@"%@", dict);
            if ([self saveTermToDatabase:dict])
            {
                _total++;
            }
        }
    }
    
    return parser;
}

-(TFHpple*) parsePage:(NSString*) params
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", TARGET_WEBSITE, params];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    return parser;
}

-(NSArray*) parseTerms:(TFHpple*)parser
{
    NSString *path = @"//div[@id='main']/table/tr/td/li/a";
    NSArray *nodes = [parser searchWithXPathQuery:path];
    NSMutableArray *arrTerms = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in nodes)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:[self extractTextFromElement:element isParent:NO] forKey:@"term"];
        [dict setObject:[element objectForKey:@"href"] forKey:@"href"];
        [arrTerms addObject:dict];
    }
    
    return arrTerms;
}

-(NSArray*) subsectionsByLetter:(TFHpple*)parser
{
    NSMutableArray *arrSubsections = [[NSMutableArray alloc] init];
    
    NSString *path = @"//div[@id='main']/a";
    NSArray *nodes;
    @try {
    nodes = [parser searchWithXPathQuery:path];
    } @catch (NSException *error)
    {
        NSLog(@"%@ = %@", error, [error userInfo]);
    }
    
    for (TFHppleElement *element in nodes)
    {
        [arrSubsections addObject:[element objectForKey:@"href"]];
    }
    
    return arrSubsections;
}

-(void) parseDefinition:(NSMutableDictionary*) dict
{
    NSString *href = [dict objectForKey:@"href"];
    NSRange range = [href rangeOfString:@"=" options:NSBackwardsSearch];
    NSString *id_ = [href substringFromIndex:range.location+1];
    [dict setObject:id_ forKey:@"id"];
    
    TFHpple *parser = [self parsePage:href];
    NSString *path = @"//div[@id='main']";
    NSArray *nodes = [parser searchWithXPathQuery:path];
    
    for (TFHppleElement *element in nodes)
    {
        // look for each <strong> tag...
        dict = [self extractStrongFromElement:element dest:dict];
    }
}

-(NSString*) extractTextFromElement:(TFHppleElement*)element isParent:(BOOL)parent
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    for (TFHppleElement *e in parent?element.parent.children:element.children)
    {
        if ([e hasChildren])
        {
            for (TFHppleElement *child in e.children)
            {
                if ([[e tagName] isEqualToString:@"super"])
                {
                    [text appendFormat:@"%@", [JJJUtil superScriptOf:[JJJUtil toUTF8:[child content]]]];
                }
                else if ([[e tagName] isEqualToString:@"sub"])
                {
                    [text appendFormat:@"%@", [JJJUtil subScriptOf:[JJJUtil toUTF8:[child content]]]];
                }
                else if ([[e tagName] isEqualToString:@"a"])
                {
                    [text appendFormat:@"%@", [JJJUtil toUTF8:[JJJUtil trim:[child content]]]];
                }
            }
        }
        else
        {
            if ([[e tagName] isEqualToString:@"text"])
            {
                NSString *content = [JJJUtil toUTF8:[e content]];

                if (![JJJUtil isEmptyString:[JJJUtil trim:content]] &&
                    ![JJJUtil string:content containsString:@"Pronunciation"] &&
                    ![JJJUtil string:content containsString:@"Synonyms"] &&
                    ![JJJUtil string:content containsString:@"Definitions"] &&
                    ![JJJUtil string:content containsString:@"See"])
                {
                    [text appendFormat:@"%@", content];
                }
            }
        }
    }
    
    return text;
}

-(NSArray*) extractDefinitionsFromElement:(TFHppleElement*)element
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSString *text = [JJJUtil trim:[self extractTextFromElement:element isParent:YES]];
    NSString *delim = @"$";
    
    for (int i=1; i<11; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%d. ", i];
        text = [text stringByReplacingOccurrencesOfString:num withString:delim];
    }

    for (NSString *token in [text componentsSeparatedByString:delim])
    {
        NSString *trimmed = [JJJUtil trim:token];
        
        if ([trimmed length] > 0)
        {
            [arrResult addObject:trimmed];
        }
    }
    return arrResult;
}

-(NSArray*) extractSynonymsFromElement:(TFHppleElement*)element
{
    NSMutableArray *arrResult = [[NSMutableArray alloc] init];
    NSString *text = [JJJUtil trim:[self extractTextFromElement:element isParent:YES]];
    NSString *delim = @",";
    
    for (NSString *token in [text componentsSeparatedByString:delim])
    {
        NSString *trimmed = [JJJUtil trim:token];
        
        if ([trimmed length] > 0)
        {
            [arrResult addObject:trimmed];
        }
    }
    return arrResult;
}

-(NSMutableDictionary*) extractStrongFromElement:(TFHppleElement*)element dest:(NSMutableDictionary*)dest
{
    if ([element hasChildren])
    {
        NSString *strong;
    
        for (TFHppleElement *child in element.children)
        {
            if (strong)
            {
                if ([[child tagName] isEqualToString:@"text"])
                {
                    if ([strong isEqualToString:@"Synonyms:"])
                    {
                        NSArray *arr = [self extractSynonymsFromElement:child];
                        if (arr && [arr count] > 0)
                        {
                            [dest setObject:arr forKey:strong];
                        }
                    }
                    else if ([strong isEqualToString:@"See:"])
                    {
                        NSArray *arr = [self extractSynonymsFromElement:child];
                        if (arr && [arr count] > 0)
                        {
                            [dest setObject:arr forKey:strong];
                        }
                    }
                    else if ([strong isEqualToString:@"Pronunciation:"])
                    {
                        [dest setObject:[JJJUtil trim:[JJJUtil toUTF8:[child content]]] forKey:strong];
                    }
                }
                // Definitions:
                else
                {
                    NSArray *arr = [self extractDefinitionsFromElement:child];
                    if (arr && [arr count] > 0)
                    {
                        [dest setObject:arr forKey:strong];
                    }
                }
                
                strong = nil;
            }
            
            if ([[child tagName] isEqualToString:@"strong"])
            {
                NSString *content = [[child firstChild] content];
                
                if ([JJJUtil string:content containsString:@"Pronunciation"] ||
                    [JJJUtil string:content containsString:@"Synonyms"] ||
                    [JJJUtil string:content containsString:@"Definitions"] ||
                    [JJJUtil string:content containsString:@"See"])
                {
                    strong = content;
                }
            }
            
            if ([child hasChildren])
            {
                dest = [self extractStrongFromElement:child dest:dest];
            }
        }
    }
    
    return dest;
}

-(BOOL) saveTermToDatabase:(NSDictionary*)dict
{
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DictionaryTerm *d = [DictionaryTerm MR_createInContext:currentContext];
    d.termId = [dict objectForKey:@"id"];
    d.term = [dict objectForKey:@"term"];
    d.pronunciation = [dict objectForKey:@"Pronunciation:"];
    if ([JJJUtil isAlphaStart:d.term])
    {
        d.termInitial = [[d.term substringToIndex:1] uppercaseString];
    }
    else
    {
        d.termInitial = @"#";
    }
    [currentContext MR_save];
    
    if ([dict objectForKey:@"Definitions:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"Definitions:"])
        {
            DictionaryDefinition *dd = [DictionaryDefinition MR_createInContext:currentContext];
            dd.definition = x;
            [set addObject:dd];
        }
        
        [d addDefinition:set];
        [currentContext MR_save];
    }
    
    if ([dict objectForKey:@"Synonyms:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"Synonyms:"])
        {
            DictionarySynonym *ds = [DictionarySynonym MR_createInContext:currentContext];
            ds.term = x;
            [set addObject:ds];
        }
        
        [d addSynonym:set];
        [currentContext MR_save];
    }
    
    if ([dict objectForKey:@"See:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"See:"])
        {
            DictionaryXRef *dx = [DictionaryXRef MR_createInContext:currentContext];
            dx.term = x;
            [set addObject:dx];
        }
        
        [d addXref:set];
        [currentContext MR_save];
    }
    
    return YES;
}

- (BOOL) isTermInDatabase:(NSString*)term
{
    NSArray *arr = [DictionaryTerm MR_findByAttribute:@"term" withValue:term];
    
    return arr && arr.count > 0;
}

@end

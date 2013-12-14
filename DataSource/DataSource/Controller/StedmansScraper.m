//
//  StedmansScraper.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "StedmansScraper.h"

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
//                    @"9",
                    @"a",
                    @"b",
                    @"c",
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
        
    NSLog(@"Started: %@; Ended: %@; Total: %@", dateStart, [NSDate date], dictTotals);
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
                    [text appendFormat:@"%@", [Util superScriptOf:[Util toUTF8:[child content]]]];
                }
                else if ([[e tagName] isEqualToString:@"sub"])
                {
                    [text appendFormat:@"%@", [Util subScriptOf:[Util toUTF8:[child content]]]];
                }
                else if ([[e tagName] isEqualToString:@"a"])
                {
                    [text appendFormat:@"%@", [Util toUTF8:[Util trim:[child content]]]];
                }
            }
        }
        else
        {
            if ([[e tagName] isEqualToString:@"text"])
            {
                NSString *content = [Util toUTF8:[e content]];

                if (![Util isEmptyString:[Util trim:content]] &&
                    ![Util string:content containsString:@"Pronunciation"] &&
                    ![Util string:content containsString:@"Synonyms"] &&
                    ![Util string:content containsString:@"Definitions"] &&
                    ![Util string:content containsString:@"See"])
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
    NSString *text = [Util trim:[self extractTextFromElement:element isParent:YES]];
    NSString *delim = @"$";
    
    for (int i=1; i<11; i++)
    {
        NSString *num = [NSString stringWithFormat:@"%d. ", i];
        text = [text stringByReplacingOccurrencesOfString:num withString:delim];
    }

    for (NSString *token in [text componentsSeparatedByString:delim])
    {
        NSString *trimmed = [Util trim:token];
        
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
    NSString *text = [Util trim:[self extractTextFromElement:element isParent:YES]];
    NSString *delim = @",";
    
    for (NSString *token in [text componentsSeparatedByString:delim])
    {
        NSString *trimmed = [Util trim:token];
        
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
                        [dest setObject:[Util trim:[Util toUTF8:[child content]]] forKey:strong];
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
                
                if ([Util string:content containsString:@"Pronunciation"] ||
                    [Util string:content containsString:@"Synonyms"] ||
                    [Util string:content containsString:@"Definitions"] ||
                    [Util string:content containsString:@"See"])
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
    DictionaryTerm *d = [[Database sharedInstance] createManagedObject:@"DictionaryTerm"];
    d.dictionaryId = [dict objectForKey:@"id"];
    d.term = [dict objectForKey:@"term"];
    d.pronunciation = [dict objectForKey:@"Pronunciation:"];
    
    NSError *error;
    if (![[[Database sharedInstance] managedObjectContext] save:&error])
    {
        NSLog(@"Save error: %@", [error localizedDescription]);
        return NO;
    }

    if ([dict objectForKey:@"Definitions:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"Definitions:"])
        {
            DictionaryDefinition *dd = [[Database sharedInstance] createManagedObject:@"DictionaryDefinition"];
            dd.definition = x;
            [set addObject:dd];
        }
        
        [d addDictionaryDefinition:set];
        if (![[[Database sharedInstance] managedObjectContext] save:&error])
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
            return NO;
        }
    }
    
    if ([dict objectForKey:@"Synonyms:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"Synonyms:"])
        {
            DictionarySynonym *ds = [[Database sharedInstance] createManagedObject:@"DictionarySynonym"];
            ds.term = x;
            [set addObject:ds];
        }
        
        [d addDictionarySynonym:set];
        if (![[[Database sharedInstance] managedObjectContext] save:&error])
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
            return NO;
        }
    }
    
    if ([dict objectForKey:@"See:"])
    {
        NSMutableSet *set = [[NSMutableSet alloc] init];
        
        for (NSString *x in [dict objectForKey:@"See:"])
        {
            DictionaryXRef *dx = [[Database sharedInstance] createManagedObject:@"DictionaryXRef"];
            dx.term = x;
            [set addObject:dx];
        }
        
        [d addDictionaryXRef:set];
        if (![[[Database sharedInstance] managedObjectContext] save:&error])
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) isTermInDatabase:(NSString*)term
{
    NSArray *arr = [[Database sharedInstance] find:@"DictionaryTerm"
                                        columnName:@"term"
                                       columnValue:term
                                  relationshipKeys:nil
                                           sorters:nil];
    return arr && arr.count > 0;
}

@end

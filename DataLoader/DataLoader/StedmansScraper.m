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
//    if ([[Database sharedInstance] tableCount:@"Dictionary"] == 0)
    {
        NSMutableDictionary *dictTotals = [[NSMutableDictionary alloc] init];
        
        // #1 scrape each letter
        for (NSString *letter in _letters)
        {
            int total = 0;
            
            TFHpple *parser = [self parsePage:[NSString stringWithFormat:@"?l=%@", letter]];
        
            // #2 scrape terms in the 1st page letter
            for (NSMutableDictionary *dict in [self parseTerms:parser])
            {
                [self parseDefinition:dict];
                NSLog(@"Inserting... %@", [dict objectForKey:@"term"]);
                [self saveTermToDatabase:dict];
                total++;
            }

            // #3 scrape terms in the subsections of of each letter
            for (NSString *sub in [self subsectionsByLetter:parser])
            {
                TFHpple *parser2 = [self parsePage:[NSString stringWithFormat:@"%@", sub]];
            
                for (NSMutableDictionary *dict2 in [self parseTerms:parser2])
                {
                    [self parseDefinition:dict2];
                    NSLog(@"Inserting... %@", [dict2 objectForKey:@"term"]);
                    [self saveTermToDatabase:dict2];
                    total++;
                }
            }
            
            [dictTotals setObject:[NSNumber numberWithInt:total] forKey:letter];
        }
        
        NSLog(@"%@", dictTotals);
    }
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
        NSMutableString *term = [[NSMutableString alloc] init];
        
        if ([element hasChildren])
        {
            for (TFHppleElement *child in element.children)
            {
                if ([[child tagName] isEqualToString:@"text"])
                {
                    [term appendFormat:@"%@", [child content]];
                }
                else if ([[child tagName] isEqualToString:@"super"])
                {
                    [term appendFormat:@"%@", [[child firstChild] content]];
                }
            }
            
        }
        [dict setObject:term forKey:@"term"];
        [dict setObject:[element objectForKey:@"href"] forKey:@"href"];
        [arrTerms addObject:dict];
    }
    
    return arrTerms;
}

-(NSArray*) subsectionsByLetter:(TFHpple*)parser
{
    NSMutableArray *arrSubsections = [[NSMutableArray alloc] init];
    
    NSString *path = @"//div[@id='main']/a";
    NSArray *nodes = [parser searchWithXPathQuery:path];
    
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

-(NSMutableDictionary*) extractStrongFromElement:(TFHppleElement*)element dest:(NSMutableDictionary*)dest
{
    if ([element hasChildren])
    {
        NSString *strong;
    
        for (TFHppleElement * child in element.children)
        {
            if (strong)
            {
                if ([[child tagName] isEqualToString:@"text"])
                {
                    // Synonyms:
                    if ([strong isEqualToString:@"Synonyms:"])
                    {
                        for (TFHppleElement *syn in child.parent.children)
                        {
                            if ([[syn tagName] isEqualToString:@"a"])
                            {
                                NSMutableArray *synonyms = [[NSMutableArray alloc] init];
                                
                                for (TFHppleElement *a in syn.children)
                                {
                                    [synonyms addObject:[[syn firstChild] content]];
                                }
                                [dest setObject:synonyms forKey:strong];
                            }
                        }
                    }
                    else
                    {
                        // Pronunciation:
                        NSString *text = [[child content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        [dest setObject:text forKey:strong];
                    }
                }
                // Definitions:
                else
                {
                    for (TFHppleElement *desc in child.parent.children)
                    {
                        if ([[desc tagName] isEqualToString:@"text"])
                        {
                            
                            NSString *text = [[desc content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            [dest setObject:text forKey:strong];
                        }
                    }
                }
                
                strong = nil;
            }
            
            NSString *content = [[child firstChild] content];
            if ([[child tagName] isEqualToString:@"strong"])
            {
                if ([Util string:content containsString:@"Pronunciation"] ||
                    [Util string:content containsString:@"Synonym"] ||
                    [Util string:content containsString:@"Definitions"])
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

-(void) saveTermToDatabase:(NSDictionary*)dict
{
    Dictionary *d = [[Database sharedInstance] createManagedObject:@"Dictionary"];

    d.dictionaryId = [dict objectForKey:@"id"];
    d.term = [dict objectForKey:@"term"];
    d.definition = [dict objectForKey:@"Definitions:"];
    d.pronunciation = [dict objectForKey:@"Pronunciation:"];
    
    NSError *error;
    if (![[[Database sharedInstance] managedObjectContext] save:&error])
    {
        NSLog(@"Save error: %@", [error localizedDescription]);
    }

    if ([dict objectForKey:@"Synonyms:"])
    {
        for (NSString *syn in [dict objectForKey:@"Synonyms:"])
        {
            DictionarySynonym *ds = [[Database sharedInstance] createManagedObject:@"DictionarySynonym"];
            
            ds.term = syn;
            
            NSArray *array = [[Database sharedInstance] find:@"Dictionary"
                                  columnName:@"dictionaryId"
                                 columnValue:[dict objectForKey:@"id"]
                            relationshipKeys:nil
                                     sorters:nil];
            if (array && array.count > 0)
            {
                ds.dictionaryId = [array objectAtIndex:0];
            }
            
            NSError *error2;
            if (![[[Database sharedInstance] managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error localizedDescription]);
            }
        }
    }
}

@end

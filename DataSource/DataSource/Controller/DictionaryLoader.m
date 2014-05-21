//
//  DictionaryLoader.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryLoader.h"
#import "JJJ/JJJ.h"
#import "Database.h"
#import "DictionarySynonym.h"
#import "DictionaryTerm.h"
#import "DictionaryXRef.h"
#import "TFHpple.h"

@implementation DictionaryLoader
{
    NSArray *_letters;
    int _total;

    CHCSVParser *_termsParser;
    CHCSVParser *_synonymsParser;
    CHCSVParser *_xrefsParser;
    CHCSVWriter *_termsWriter;
    CHCSVWriter *_synonymsWriter;
    CHCSVWriter *_xrefsWriter;
    NSMutableDictionary *_currentLine;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        _letters = [NSArray arrayWithObjects:
//                    @"9",
//                    @"a",
//                    @"b",
//                    @"c",
//                    @"d",
//                    @"e",
                    @"f",
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

    NSURL *appDocs = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *termsURL = [appDocs URLByAppendingPathComponent:TERMS_CSV_FILE];
    NSOutputStream *termsOut = [[NSOutputStream alloc] initWithURL:termsURL append:[[NSFileManager defaultManager] fileExistsAtPath:[termsURL path]]];
    _termsWriter = [[CHCSVWriter alloc] initWithOutputStream:termsOut encoding:NSUTF8StringEncoding delimiter:CSV_DELIMETER];
    
    NSURL *synsURL = [appDocs URLByAppendingPathComponent:SYNONYMS_CSV_FILE];
    NSOutputStream *synsOut = [[NSOutputStream alloc] initWithURL:synsURL append:[[NSFileManager defaultManager] fileExistsAtPath:[synsURL path]]];
    _synonymsWriter = [[CHCSVWriter alloc] initWithOutputStream:synsOut encoding:NSUTF8StringEncoding delimiter:CSV_DELIMETER];
    
    NSURL *xrefsURL = [appDocs URLByAppendingPathComponent:XREFS_CSV_FILE];
    NSOutputStream *xrefsOut = [[NSOutputStream alloc] initWithURL:xrefsURL append:[[NSFileManager defaultManager] fileExistsAtPath:[xrefsURL path]]];
    _xrefsWriter = [[CHCSVWriter alloc] initWithOutputStream:xrefsOut encoding:NSUTF8StringEncoding delimiter:CSV_DELIMETER];
    
    // #1 scrape each letter
    for (NSString *letter in _letters)
    {
        // #2 scrape terms in the 1st page letter
        TFHpple *parser = [self scrapePageTerms:[NSString stringWithFormat:@"?l=%@", letter]];

#ifndef SCRAPE_LIMIT
        // #3 scrape terms in the subsections of the letter
        for (NSString *sub in [self subsectionsByLetter:parser])
        {
            [self scrapePageTerms:[NSString stringWithFormat:@"%@", sub]];
        }
        
        [dictTotals setObject:[NSNumber numberWithInt:_total] forKey:letter];
        _total = 0;
#endif
    }
    
    [_termsWriter closeStream];
    [_synonymsWriter closeStream];
    [_xrefsWriter closeStream];
    
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
        [self parseDefinition:dict];
        NSLog(@"%@", dict);
        [self saveTermToCSV:dict];
        _total++;
        
#ifdef SCRAPE_LIMIT
        if (_total == 10)
        {
            _total = 0;
            break;
        }
#endif
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

    nodes = [parser searchWithXPathQuery:path];

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
//    NSString *path = @"//div[@id='main']";
    NSString *path = @"//div[@class='definitionbox']";
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

-(void) saveTermToCSV:(NSDictionary*)dict
{
    NSMutableArray *arrTerms = [[NSMutableArray alloc] initWithObjects:[dict objectForKey:@"id"],
                                 [dict objectForKey:@"term"], nil];
    
    
    if ([dict objectForKey:@"Pronunciation:"])
    {
        [arrTerms addObject:[dict objectForKey:@"Pronunciation:"]];
    }
    else
    {
        [arrTerms addObject:@""];
    }
    
    if ([dict objectForKey:@"Definitions:"])
    {
        NSMutableString *buffer = [[NSMutableString alloc] init];
        
        for (NSString *x in [dict objectForKey:@"Definitions:"])
        {
            [buffer appendFormat:@"%@%@", x, COMPOUND_SEPARATOR];
        }
        [arrTerms addObject:[buffer substringToIndex:buffer.length-3]];
    }
    else
    {
        [arrTerms addObject:@""];
    }
    [_termsWriter writeLineOfFields:arrTerms];
    
    if ([dict objectForKey:@"Synonyms:"])
    {
        for (NSString *x in [dict objectForKey:@"Synonyms:"])
        {
            [_synonymsWriter writeLineOfFields:@[[dict objectForKey:@"id"], x]];
        }
    }
    
    if ([dict objectForKey:@"See:"])
    {
        for (NSString *x in [dict objectForKey:@"See:"])
        {
            [_xrefsWriter writeLineOfFields:@[[dict objectForKey:@"id"], x]];
        }
    }
}

-(void) csv2CoreData
{
    NSDate *dateStart = [NSDate date];
    
    [[Database sharedInstance ] setupDb];
    
    NSStringEncoding encoding = NSUTF8StringEncoding;
    
    NSString *path = [NSString stringWithFormat:@"%@/Data/%@", [[NSBundle mainBundle] resourcePath], TERMS_CSV_FILE];
    NSInputStream *is = [[NSInputStream alloc] initWithFileAtPath:path];
    _termsParser = [[CHCSVParser alloc] initWithInputStream:is usedEncoding:&encoding delimiter:CSV_DELIMETER];
    _termsParser.sanitizesFields = YES;
    _termsParser.delegate = self;
    [_termsParser parse];
    [is close];
    
    path = [NSString stringWithFormat:@"%@/Data/%@", [[NSBundle mainBundle] resourcePath], SYNONYMS_CSV_FILE];
    is = [[NSInputStream alloc] initWithFileAtPath:path];
    _synonymsParser = [[CHCSVParser alloc] initWithInputStream:is usedEncoding:&encoding delimiter:CSV_DELIMETER];
    _synonymsParser.sanitizesFields = YES;
    _synonymsParser.delegate = self;
    [_synonymsParser parse];
    [is close];
    
    path = [NSString stringWithFormat:@"%@/Data/%@", [[NSBundle mainBundle] resourcePath], XREFS_CSV_FILE];
    is = [[NSInputStream alloc] initWithFileAtPath:path];
    _xrefsParser = [[CHCSVParser alloc] initWithInputStream:is usedEncoding:&encoding delimiter:CSV_DELIMETER];
    _xrefsParser.sanitizesFields = YES;
    _xrefsParser.delegate = self;
    [_xrefsParser parse];
    [is close];
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
    for (NSString *x in [JJJUtil alphabetWithWildcard])
    {
        NSLog(@"%@=%tu", x, [DictionaryTerm MR_findByAttribute:@"termInitial" withValue:x].count);
    }
    [[Database sharedInstance ] closeDb];
}

-(void) saveTermToDatabase:(NSDictionary*)dict
{
    if (![dict objectForKey:@"term"])
    {
        return;
    }
    else
    {
        if ([DictionaryTerm MR_findFirstByAttribute:@"term" withValue:[dict objectForKey:@"term"]])
        {
            return;
        }
    }
    
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    DictionaryTerm *d = [DictionaryTerm MR_createInContext:currentContext];
    d.termId = [dict objectForKey:@"id"];
    d.term = [dict objectForKey:@"term"];
    if ([JJJUtil isAlphaStart:d.term])
    {
        d.termInitial = [[d.term substringToIndex:1] uppercaseString];
    }
    else
    {
        d.termInitial = @"#";
    }
    
    NSString *pronunciation = [dict objectForKey:@"Pronunciation:"];
    if (pronunciation && pronunciation.length > 0)
    {
        d.pronunciation = pronunciation;
    }
    
    NSString *definition = [dict objectForKey:@"Definitions:"];
    if (definition && definition.length > 0)
    {
        d.definition = definition;
    }
    
    [currentContext MR_save];
}

-(void) saveSynonymToDatabase:(NSDictionary*)dict
{
    if (![dict objectForKey:@"term"])
    {
        return;
    }
    
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    DictionaryTerm *term = [DictionaryTerm MR_findFirstByAttribute:@"termId" withValue:[dict objectForKey:@"id"]];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"termId == %@", [dict objectForKey:@"id"]];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"synonym == %@", [dict objectForKey:@"term"]];
    NSPredicate *compred = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred1, pred2]];
    
    if (term && ![DictionarySynonym MR_findFirstWithPredicate:compred])
    {
        DictionarySynonym *d = [DictionarySynonym MR_createInContext:currentContext];
        d.termId = [dict objectForKey:@"id"];
        d.synonym = [dict objectForKey:@"term"];
        d.term = term;
    
        [currentContext MR_save];
    }
}

-(void) saveXrefToDatabase:(NSDictionary*)dict
{
    if (![dict objectForKey:@"term"])
    {
        return;
    }
    
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    DictionaryTerm *term = [DictionaryTerm MR_findFirstByAttribute:@"termId" withValue:[dict objectForKey:@"id"]];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"termId == %@", [dict objectForKey:@"id"]];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"xref == %@", [dict objectForKey:@"term"]];
    NSPredicate *compred = [NSCompoundPredicate andPredicateWithSubpredicates:@[pred1, pred2]];
    
    if (term && ![DictionaryXRef MR_findFirstWithPredicate:compred])
    {
        DictionaryXRef *d = [DictionaryXRef MR_createInContext:currentContext];
        d.termId = [dict objectForKey:@"id"];
        d.xref = [dict objectForKey:@"term"];
        d.term = term;
    
        [currentContext MR_save];
    }
}

#pragma mark - CHCSVParserDelegate
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    NSLog(@"Parsing line #%tu...", recordNumber);
    _currentLine = [[NSMutableDictionary alloc] init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    NSLog(@"%@", _currentLine);
    
    if (parser == _termsParser)
    {
        if (![DictionaryTerm MR_findFirstByAttribute:@"term" withValue:[_currentLine objectForKey:@"term"]])
        {
            [self saveTermToDatabase:_currentLine];
        }
    }
    else if (parser == _synonymsParser)
    {
        [self saveSynonymToDatabase:_currentLine];
    }
    else if (parser == _xrefsParser)
    {
        [self saveXrefToDatabase:_currentLine];
    }
    
    [_currentLine removeAllObjects];
    _currentLine = nil;
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    if (parser == _termsParser)
    {
        switch (fieldIndex)
        {
            case 0:
            {
                [_currentLine setObject:field forKey:@"id"];
                break;
            }
            case 1:
            {
                [_currentLine setObject:field forKey:@"term"];
                break;
            }
            case 2:
            {
                [_currentLine setObject:field forKey:@"Pronunciation:"];
                break;
            }
            case 3:
            {
                [_currentLine setObject:field forKey:@"Definitions:"];
                break;
            }
        }
    }
    else if (parser == _synonymsParser || parser == _xrefsParser)
    {
        switch (fieldIndex)
        {
            case 0:
            {
                [_currentLine setObject:field forKey:@"id"];
                break;
            }
            case 1:
            {
                [_currentLine setObject:field forKey:@"term"];
                break;
            }
        }
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error userInfo]);
}

@end

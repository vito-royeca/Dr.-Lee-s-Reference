//
//  ProceduresLoader.m
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ProceduresLoader.h"
#import "Database.h"
#import "JJJ/JJJ.h"
#import "ICD10Procedure.h"
#import "ICD10ProcedureDefinition.h"
#import "ICD10ProcedureIndex.h"
#import "TFHpple.h"

#include <stdio.h>

@implementation ProceduresLoader

- (void) loadProcedures
{
    NSDate *dateStart = [NSDate date];
    [[Database sharedInstance] setupDb];
    
    NSUInteger count = [ICD10Procedure MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Tabular];
        [self updateICD10Tabular];
    }
    
    count = [ICD10ProcedureIndex MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Index];
    }

    count = [ICD10ProcedureDefinition MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Definition];
    }
    
    
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
    NSLog(@"Tabular = %tu", [ICD10Procedure MR_countOfEntities]);
    NSLog(@"Definition = %tu", [ICD10ProcedureDefinition MR_countOfEntities]);
    NSLog(@"Index = %tu", [ICD10ProcedureIndex MR_countOfEntities]);
    
    [[Database sharedInstance ] closeDb];
}

- (void) loadICD10Tabular
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/icd10pcs_tabular_2014.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *elemPcsTable in [self elementsWithPath:@"//pcsTable" inParser:parser])
    {
        ICD10Procedure *proc1;
        ICD10Procedure *proc2;
        ICD10Procedure *proc3;
        NSString *code;
        
        for (TFHppleElement *elemAxis in elemPcsTable.children)
        {
            if ([elemAxis.tagName isEqualToString:@"axis"])
            {
                switch ([[elemAxis objectForKey:@"pos"] intValue])
                {
                    case 1:
                    {
                        proc1 = [[self findProceduresWithParentCode:code inElement:elemAxis] firstObject];
                        break;
                    }
                    case 2:
                    {
                        code = proc1.code;
                        proc2 = [[self findProceduresWithParentCode:code inElement:elemAxis] firstObject];
                        proc2.parent = proc1;
                        break;
                    }
                    case 3:
                    {
                        code = [NSString stringWithFormat:@"%@", proc2.code];
                        proc3 = [[self findProceduresWithParentCode:code inElement:elemAxis] firstObject];
                        proc3.parent = proc2;
;
                        break;
                    }
                }
                
                NSLog(@"code = %@", code);
                [currentContext MR_save];
            }
            else if ([elemAxis.tagName isEqualToString:@"pcsRow"])
            {
                NSMutableArray *arrProc4 = [[NSMutableArray alloc] init];
                NSMutableArray *arrProc5 = [[NSMutableArray alloc] init];
                NSMutableArray *arrProc6 = [[NSMutableArray alloc] init];
                NSMutableArray *arrProc7 = [[NSMutableArray alloc] init];
                
                for (TFHppleElement *elemPcsAxis in elemAxis.children)
                {
                    if ([elemPcsAxis.tagName isEqualToString:@"axis"])
                    {
                        switch ([[elemPcsAxis objectForKey:@"pos"] intValue])
                        {
                            case 4:
                            {
                                code = [NSString stringWithFormat:@"%@", proc3.code];
                                
                                for (ICD10Procedure *proc4 in [self findProceduresWithParentCode:code
                                                                                       inElement:elemPcsAxis])
                                {
                                    proc4.parent = proc3;
                                    
                                    NSLog(@"code = %@", code);
                                    [currentContext MR_save];
                                    [arrProc4 addObject:proc4];
                                }
                                break;
                            }
                            case 5:
                            {
                                for (ICD10Procedure *proc4 in arrProc4)
                                {
                                    code = [NSString stringWithFormat:@"%@", proc4.code];
                                    for (ICD10Procedure *proc5 in [self findProceduresWithParentCode:code
                                                                                           inElement:elemPcsAxis])
                                    {
                                        proc5.parent = proc4;
                                        
                                        NSLog(@"code = %@", code);
                                        [currentContext MR_save];
                                        [arrProc5 addObject:proc5];
                                    }
                                }
                                break;
                            }
                            case 6:
                            {
                                for (ICD10Procedure *proc5 in arrProc5)
                                {
                                    code = [NSString stringWithFormat:@"%@", proc5.code];
                                    for (ICD10Procedure *proc6 in [self findProceduresWithParentCode:code
                                                                                           inElement:elemPcsAxis])
                                    {
                                        proc6.parent = proc5;
                                        
                                        NSLog(@"code = %@", code);
                                        [currentContext MR_save];
                                        [arrProc6 addObject:proc6];
                                    }
                                }
                                break;
                            }
                            case 7:
                            {
                                for (ICD10Procedure *proc6 in arrProc6)
                                {
                                    code = [NSString stringWithFormat:@"%@", proc6.code];
                                    for (ICD10Procedure *proc7 in [self findProceduresWithParentCode:code
                                                                                        inElement:elemPcsAxis])
                                    {
                                        proc7.parent = proc6;
                                        
                                        NSLog(@"code = %@", code);
                                        [currentContext MR_save];
                                        [arrProc7 addObject:proc7];
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSArray*) findProceduresWithParentCode:(NSString*)parentCode inElement:(TFHppleElement*) element
{
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSMutableArray *arrProcs = [[NSMutableArray alloc] init];
    NSMutableArray *arrLabels = [[NSMutableArray alloc] init];
    
    NSString *key;
    NSString *definition;
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"title"])
        {
            key = [[child firstChild] content];
        }
        else if ([child.tagName isEqualToString:@"label"])
        {
            NSString *code = [NSString stringWithFormat:@"%@%@", parentCode?parentCode:@"", [child objectForKey:@"code"]];
            NSString *name = [[child firstChild] content];
            
            [arrLabels addObject:@{code:name}];
        }
        else if ([child.tagName isEqualToString:@"definition"])
        {
            definition = [[child firstChild] content];
        }
    }
    
    for (NSDictionary *dict in arrLabels)
    {
        NSString *code = [[dict allKeys] firstObject];
        NSString *name = [dict objectForKey:code];
        
        ICD10Procedure *proc = [ICD10Procedure MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@ AND %K == %@", @"key", key, @"code", code, @"name", name]];
        if (!proc)
        {
            proc = [ICD10Procedure MR_createEntity];
            
            proc.key = key;
            proc.code = code;
            proc.name = name;
            proc.definition = definition;
            proc.version = @"2014";
            
            [currentContext MR_save];
        }
        [arrProcs addObject:proc];
    }
    
    return arrProcs;
}

- (void) updateICD10Tabular
{
    NSString *path;
    
    path = [NSString stringWithFormat:@"%@/Data/icd10pcs_order_2014.txt", [[NSBundle mainBundle] resourcePath]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        FILE *file = fopen([path UTF8String], "r");

        // check for NULL
        while(!feof(file))
        {
            NSString *line = readLineAsNSString(file);
            // do stuff with line; line is autoreleased, so you should NOT release it (unless you also retain it beforehand)
            [self processLine:line];
        }
        fclose(file);
    }
}

-(void) processLine:(NSString*)line
{
    if (!line || line.length <= 0)
    {
        return;
    }

    NSString *code = [line substringWithRange:NSMakeRange(6, 7)];
    NSString *shortName = [JJJUtil trim:[line substringWithRange:NSMakeRange(16, 60)]];
    NSString *longName = [JJJUtil trim:[line substringFromIndex:77]];
    
    [self updateProcedureWithCode:code withShortName:shortName withLongName:longName];
}

-(void) updateProcedureWithCode:(NSString*) code withShortName:(NSString*) shortName withLongName:(NSString*) longName
{
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"code", code];
    ICD10Procedure *proc = [ICD10Procedure MR_findFirstWithPredicate:predicate];
    
    proc.shortName = shortName;
    proc.longName = longName;
    [currentContext MR_save];
}

-(void) loadICD10Index
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/icd10pcs_index_2014.xml"];
    TFHpple *parser = [self parseFile:path];
    
    for (TFHppleElement *elemLetter in [self elementsWithPath:@"//letter" inParser:parser])
    {
        for (TFHppleElement *elemAxis in elemLetter.children)
        {
            if ([elemAxis.tagName isEqualToString:@"mainTerm"])
            {
                [self findIndexInElement:elemAxis];
            }
        }
    }
}

- (ICD10ProcedureIndex*) findIndexInElement:(TFHppleElement*) element
{
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    NSMutableArray *arrTerms = [[NSMutableArray alloc] init];
    NSString *title;
    NSString *use;
    NSString *see;
    
    NSString *codes;
    ICD10Procedure *useCode;
    ICD10Procedure *seeCode;
    
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"title"])
        {
            title = [[child firstChild] content];
        }
        else if ([child.tagName isEqualToString:@"use"])
        {
            use = [[child firstChild] content];
            useCode = [self findProcedureInElement:child];
        }
        else if ([child.tagName isEqualToString:@"see"])
        {
            see = [[child firstChild] content];
            seeCode = [self findProcedureInElement:child];
        }
        else if ([child.tagName isEqualToString:@"term"])
        {
            [arrTerms addObject:[self findIndexInElement:child]];
        }
        else if ([child.tagName isEqualToString:@"code"] ||
                 [child.tagName isEqualToString:@"codes"])
        {
            codes = [[child firstChild] content];
        }
    }
    
    NSPredicate *predicate;
    
    if (title)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"title", title];
    }
    else if (!title && see)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"see", see];
    }
    else if (!title && use)
    {
        predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"use", use];
    }
    
    ICD10ProcedureIndex *index = [ICD10ProcedureIndex MR_findFirstWithPredicate:predicate];
    
    if (!index)
    {
        index = [ICD10ProcedureIndex MR_createEntity];
        
        index.title = title;
        index.use = use;
        index.useCode = useCode;
        index.see = see;
        index.seeCode = seeCode;
        index.codes = codes;
        index.version = @"2014";

        if (index.title)
        {
            if ([JJJUtil isAlphaStart:index.title])
            {
                index.titleInitial = [[index.title substringToIndex:1] uppercaseString];
            }
            else
            {
                index.titleInitial = @"#";
            }
            
        }
        [currentContext MR_save];
    }
    
    for (ICD10ProcedureIndex *term in arrTerms)
    {
        term.parent = index;
        [currentContext MR_save];
    }
    
    return index;
}

- (ICD10Procedure*) findProcedureInElement:(TFHppleElement*) element
{
    ICD10Procedure *proc;
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"tab"] ||
            [child.tagName isEqualToString:@"code"] ||
            [child.tagName isEqualToString:@"codes"])
        {
            NSString *content = [[child firstChild] content];
            
            proc = [ICD10Procedure MR_findFirstByAttribute:@"code" withValue:content];
            break;
        }
    }
    
    return proc;
}

- (void) loadICD10Definition
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/icd10pcs_definitions_2014.xml"];
    TFHpple *parser = [self parseFile:path];
    
    NSMutableString *code = [[NSMutableString alloc] init];
    
    for (TFHppleElement *elemSection in [self elementsWithPath:@"//section" inParser:parser])
    {
        NSString *code =  [elemSection objectForKey:@"code"];
        
        for (TFHppleElement *elemAxis in elemSection.children)
        {
            int pos = [[elemAxis objectForKey:@"code"] intValue];
            NSString *title;
            
            for (TFHppleElement *elemTerms in elemAxis.children)
            {
                if ([elemTerms.tagName isEqualToString:@"terms"])
                {
                    title = [[elemTerms firstChild] content];
                }
                else if ([elemTerms.tagName isEqualToString:@"terms"])
                {
                    NSMutableString *titles = [[NSMutableString alloc] init];
                    NSMutableString *definitions = [[NSMutableString alloc] init];
                    NSMutableString *explanations = [[NSMutableString alloc] init];
                    NSMutableString *includes = [[NSMutableString alloc] init];
                    
                    for (TFHppleElement *elem in elemTerms.children)
                    {
                        NSString *content = [[elem firstChild] content];
                        
                        if ([elemTerms.tagName isEqualToString:@"title"])
                        {
                            [titles appendFormat:@"%@%@", titles.length > 0 ? COMPOUND_SEPARATOR : @"", content];
                            
                        }
                        else if ([elemTerms.tagName isEqualToString:@"definition"])
                        {
                            [definitions appendFormat:@"%@%@", titles.length > 0 ? COMPOUND_SEPARATOR : @"", content];
                        }
                        else if ([elemTerms.tagName isEqualToString:@"explanation"])
                        {
                            [explanations appendFormat:@"%@%@", titles.length > 0 ? COMPOUND_SEPARATOR : @"", content];
                        }
                        else if ([elemTerms.tagName isEqualToString:@"includes"])
                        {
                            [includes appendFormat:@"%@%@", titles.length > 0 ? COMPOUND_SEPARATOR : @"", content];
                        }
                    }
                }
            }
            
            
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"%K == %@", @"code", code];
            NSPredicate *predicate2;
            
            switch (pos)
            {
                case 3:
                {
                    predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"code", code];
                    break;
                }
                case 4:
                {
                    break;
                }
                case 5:
                {
                    break;
                }
                case 6:
                {
                    break;
                }
                case 7:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            
            
        }
    }
}

#pragma mark - general helper methods
-(TFHpple*) parseFile:(NSString*) file
{
    NSData *data = [NSData dataWithContentsOfFile:file];
    TFHpple *parser = [TFHpple hppleWithXMLData:data];
    
    return parser;
}

-(NSArray*) elementsWithPath:(NSString*)path inParser:(TFHpple*)parser
{
    return [parser searchWithXPathQuery:path];
}

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:512];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}



@end

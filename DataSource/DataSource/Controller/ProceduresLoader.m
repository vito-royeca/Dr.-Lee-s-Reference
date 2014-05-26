//
//  ProceduresLoader.m
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ProceduresLoader.h"
#import "Database.h"
#import "ICD10Procedure.h"
#import "ICD10ProcedureDefinition.h"
#import "ICD10ProcedureIndex.h"
#import "TFHpple.h"

@implementation ProceduresLoader

- (void) loadProcedures
{
    NSDate *dateStart = [NSDate date];
    [[Database sharedInstance] setupDb];
    
    NSUInteger count = [ICD10Procedure MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Tabular];
    }
    
    count = [ICD10ProcedureDefinition MR_countOfEntities];
    if (count == 0)
    {
//        [self loadICD10Definition];
    }
    
    count = [ICD10ProcedureIndex MR_countOfEntities];
    if (count == 0)
    {
//        [self loadICD10Index];
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
        NSMutableArray *codes;
        NSString *code;
        
        for (TFHppleElement *elemAxis in elemPcsTable.children)
        {
            if ([elemAxis.tagName isEqualToString:@"axis"])
            {
                switch ([[elemAxis objectForKey:@"pos"] intValue])
                {
                    case 1:
                    {
                        proc1 = [[self findProceduresWithParentCode:code
                                                               from:elemAxis
                                                         insertToDB:YES] firstObject];
                        break;
                    }
                    case 2:
                    {
                        code = proc1.code;
                        proc2 = [[self findProceduresWithParentCode:code
                                                               from:elemAxis
                                                         insertToDB:YES] firstObject];
                        proc2.parent = proc1;
                        break;
                    }
                    case 3:
                    {
                        code = [NSString stringWithFormat:@"%@", proc2.code];
                        proc3 = [[self findProceduresWithParentCode:code
                                                               from:elemAxis
                                                         insertToDB:YES] firstObject];
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
                for (TFHppleElement *elemPcsAxis in elemAxis.children)
                {
                    if ([elemPcsAxis.tagName isEqualToString:@"axis"])
                    {
                        switch ([[elemPcsAxis objectForKey:@"pos"] intValue])
                        {
                            case 4:
                            {
                                code = [NSString stringWithFormat:@"%@", proc3.code];
                                codes = [self findProceduresWithParentCode:code
                                                                      from:elemPcsAxis
                                                                insertToDB:NO];
//                                for (ICD10Procedure *proc4 in codes)
//                                {
//                                    proc4.parent = proc3;
//                                    
//                                    NSLog(@"code = %@", code);
//                                    [currentContext MR_save];
//                                }
                                break;
                            }
                            case 5:
                            {
                                code = [NSString stringWithFormat:@"%@", proc3.code];
                                codes = [self findProceduresWithParentCode:code
                                                                      from:elemPcsAxis
                                                                insertToDB:NO];
//                                for (ICD10Procedure *proc4 in codes)
//                                {
//                                    code = [NSString stringWithFormat:@"%@", proc4.code];
//                                    codes = [self findProceduresWithParentCode:code
//                                                                          from:elemPcsAxis
//                                                                    insertToDB:NO];
//                                    for (ICD10Procedure *proc5 in codes)
//                                    {
//                                        proc5.parent = proc4;
//                                        
//                                        NSLog(@"code = %@", code);
//                                        [currentContext MR_save];
//                                    }
//                                }
                                break;
                            }
                            case 6:
                            {
                                code = [NSString stringWithFormat:@"%@", proc3.code];
                                codes = [self findProceduresWithParentCode:code
                                                                      from:elemPcsAxis
                                                                insertToDB:NO];
//                                for (ICD10Procedure *proc4 in codes)
//                                {
//                                    code = [NSString stringWithFormat:@"%@", proc4.code];
//                                    codes = [self findProceduresWithParentCode:code
//                                                                          from:elemPcsAxis
//                                                                    insertToDB:NO];
//                                    for (ICD10Procedure *proc5 in codes)
//                                    {
//                                        code = [NSString stringWithFormat:@"%@", proc5.code];
//                                        codes = [self findProceduresWithParentCode:code
//                                                                              from:elemPcsAxis
//                                                                        insertToDB:NO];
//                                        for (ICD10Procedure *proc6 in codes)
//                                        {
//                                            proc6.parent = proc5;
//                                            
//                                            NSLog(@"code = %@", code);
//                                            [currentContext MR_save];
//                                        }
//                                    }
//                                }
                                break;
                            }
                            case 7:
                            {
                                code = [NSString stringWithFormat:@"%@", proc3.code];
                                codes = [self findProceduresWithParentCode:code
                                                                      from:elemPcsAxis
                                                                insertToDB:NO];
                                for (ICD10Procedure *proc4 in codes)
                                {
                                    code = [NSString stringWithFormat:@"%@", proc4.code];
                                    codes = [self findProceduresWithParentCode:code
                                                                          from:elemPcsAxis
                                                                    insertToDB:NO];
                                    for (ICD10Procedure *proc5 in codes)
                                    {
                                        code = [NSString stringWithFormat:@"%@", proc5.code];
                                        codes = [self findProceduresWithParentCode:code
                                                                              from:elemPcsAxis
                                                                        insertToDB:NO];
                                        for (ICD10Procedure *proc6 in codes)
                                        {
                                            code = [NSString stringWithFormat:@"%@", proc6.code];
                                            codes = [self findProceduresWithParentCode:code
                                                                                  from:elemPcsAxis
                                                                            insertToDB:NO];
                                            for (ICD10Procedure *proc7 in codes)
                                            {
                                                proc7.parent = proc6;
                                                
                                                NSLog(@"code = %@", code);
                                                [currentContext MR_save];
                                            }
                                        }
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

- (NSArray*) findProceduresWithParentCode:(NSString*)parentCode from:(TFHppleElement*) element insertToDB:(BOOL)insert
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
            
            if (insert)
            {
                [currentContext MR_save];
                proc = [ICD10Procedure MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@ AND %K == %@", @"key", key, @"code", code, @"name", name]];
            }
        }
        
        [arrProcs addObject:proc];
    }
    
    
    
    return arrProcs;
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

@end

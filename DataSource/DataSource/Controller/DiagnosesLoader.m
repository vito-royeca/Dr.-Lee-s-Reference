//
//  DiagnosesLoader.m
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DiagnosesLoader.h"
#import "JJJ/JJJ.h"
#import "ICD10.h"
#import "ICD10Diagnosis.h"
#import "TFHpple.h"

@implementation DiagnosesLoader

- (void) loadDiagnoses
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"database.sqlite"];
    
    NSDate *dateStart = [NSDate date];
    NSMutableDictionary *dictTotals = [[NSMutableDictionary alloc] init];
    
    NSUInteger count = [ICD10Diagnosis MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Diagnoses];
    }
    NSLog(@"Diagnoses = %tu", count);
    
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
    NSLog(@"Total: %@", dictTotals);
}

- (void) loadICD10Diagnoses
{
    NSError *error;
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Tabular.xml"];
    TFHpple *parser = [self parseFile:path];

    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];

    ICD10 *icd10 = [ICD10 MR_createInContext:currentContext];
    for (TFHppleElement *element in [self elementsWithPath:@"//introduction/introSection" inParser:parser])
    {
        if ([[element objectForKey:@"type"] isEqualToString:@"title"])
        {
            for (TFHppleElement *child in element.children)
            {
                if ([child.tagName isEqualToString:@"title"])
                {
//                    NSLog(@"type=%@ / title=%@", [element objectForKey:@"type"], [[child firstChild] content]);
                    icd10.longName = [[child firstChild] content];
                }
            }
        }
    }
    
//    
//    
//    for (NSDictionary *chapter in [self parseChapters:parser])
//    {
//        NSLog(@"%@ - %@", [chapter objectForKey:@"name"], [chapter objectForKey:@"desc"]);
//    }
}

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

-(NSArray*) parseChapters:(TFHpple*)parser
{
    NSString *path = @"//chapter";
    NSArray *nodes = [parser searchWithXPathQuery:path];
    NSMutableArray *arrTerms = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in nodes)
    {
        for (TFHppleElement *child in element.children)
        {
            if ([child.tagName isEqualToString:@"name"])
            {
                NSLog(@"#### name=%@", [[child firstChild] content]);
            }
            if ([child.tagName isEqualToString:@"desc"])
            {
                NSLog(@"#### desc=%@", [[child firstChild] content]);
            }
        }
    }
    
    return arrTerms;
}

@end

//
//  DiagnosesLoader.m
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DiagnosesLoader.h"
#import "JJJ/JJJ.h"
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
//    NSString *file = [[NSString alloc] initWithContentsOfFile:path
//                                                     encoding:NSUTF8StringEncoding
//                                                        error:&error];
    TFHpple *parser = [self parseFile:path];
        
    for (NSDictionary *chapter in [self parseChapters:parser])
    {
        NSLog(@"%@ - %@", [chapter objectForKey:@"name"], [chapter objectForKey:@"desc"]);
    }
}

-(TFHpple*) parseFile:(NSString*) file
{
    NSData *data = [NSData dataWithContentsOfFile:file];
    TFHpple *parser = [TFHpple hppleWithXMLData:data];
    
    return parser;
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
                TFHppleElement *e = [child.children objectAtIndex:0];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//
                [dict setObject:e.tagName forKey:@"name"];
                [dict setObject:e.content forKey:@"desc"];
//                [arrTerms addObject:dict];
            }
        }
    }
    
    return arrTerms;
}

@end

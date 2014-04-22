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

@interface DiagnosesLoader()
{
    NSArray *_arrShortNames;
}
@end

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
    _arrShortNames = @[@{@"Infectious"            : @[@"A00", @"B99"]},
                       @{@"Neoplasms"             : @[@"C00", @"D49"]},
                       @{@"Blood | Immune"        : @[@"D50", @"D89"]},
                       @{@"Endo | Nutrit | Metab" : @[@"E00", @"E89"]},
                       @{@"Mental | Behavioral"   : @[@"F01", @"F99"]},
                       @{@"Nervous System"        : @[@"G00", @"G99"]},
                       @{@"Eye | Adnexa"          : @[@"H00", @"H59"]},
                       @{@"Ear | Mastoid"         : @[@"H60", @"H95"]},
                       @{@"Circulatory"           : @[@"I00", @"I99"]},
                       @{@"Respiratory"           : @[@"J00", @"J99"]},
                       @{@"Digestive"             : @[@"K00", @"K95"]},
                       @{@"Skin | Subcutaneous"   : @[@"L00", @"L99"]},
                       @{@"Musculoskeletal"       : @[@"M00", @"M99"]},
                       @{@"Genetourinary"         : @[@"N00", @"N99"]},
                       @{@"Pregnancy | Childbirth": @[@"O00", @"O9A"]},
                       @{@"Perinatal"             : @[@"P00", @"P96"]},
                       @{@"Congenital"            : @[@"Q00", @"Q99"]},
                       @{@"Symp | Signs | Labs"   : @[@"R00", @"R99"]},
                       @{@"Injury | Poisoning"    : @[@"S00", @"T88"]},
                       @{@"External Causes"       : @[@"V00", @"Y99"]},
                       @{@"Factors | Reasons"     : @[@"Z00", @"Z99"]}];
    
    NSError *error;
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Tabular.xml"];
    TFHpple *parser = [self parseFile:path];

    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];

    for (TFHppleElement *element in [self elementsWithPath:@"//chapter" inParser:parser])
    {
        ICD10Diagnosis *chapter = [ICD10Diagnosis MR_createEntity];

        for (TFHppleElement *child in element.children)
        {
            if ([child.tagName isEqualToString:@"name"])
            {
                chapter.name = [[child firstChild] content];
                
                NSDictionary *shortName = [_arrShortNames objectAtIndex:[chapter.name integerValue]-1];
                chapter.first = [[[shortName allValues] objectAtIndex:0] objectAtIndex:0];
                chapter.last = [[[shortName allValues] objectAtIndex:0] objectAtIndex:1];
                chapter.shortName = [[shortName allKeys] objectAtIndex:0];
            }
            if ([child.tagName isEqualToString:@"desc"])
            {
                chapter.desc = [[child firstChild] content];
            }
            if ([child.tagName isEqualToString:@"includes"])
            {
                
            }
            
           
        }
        [currentContext MR_save];
    }
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

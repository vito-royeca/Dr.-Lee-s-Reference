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
#import "ICD10DiagnosisDrug.h"
#import "ICD10DiagnosisEIndex.h"
#import "ICD10DiagnosisIndex.h"
#import "ICD10DiagnosisNeoplasm.h"
#import "TFHpple.h"

@interface DiagnosesLoader()
{
    NSArray  *_arrShortNames;
}
@end

@implementation DiagnosesLoader

- (void) loadDiagnoses
{
    NSDate *dateStart = [NSDate date];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"database.sqlite"];
    
    NSUInteger count = [ICD10Diagnosis MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Tabular];
    }
    
    count = [ICD10DiagnosisNeoplasm MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Neoplasm];
    }
    
    count = [ICD10DiagnosisDrug MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Drug];
    }
    
    count = [ICD10DiagnosisIndex MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10Index];
    }
    
    count = [ICD10DiagnosisEIndex MR_countOfEntities];
    if (count == 0)
    {
        [self loadICD10EIndex];
    }
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
    NSLog(@"Tabular = %tu", [ICD10Diagnosis MR_countOfEntities]);
    NSLog(@"Neoplasm = %tu", [ICD10DiagnosisNeoplasm MR_countOfEntities]);
    NSLog(@"Drug = %tu", [ICD10DiagnosisDrug MR_countOfEntities]);
    NSLog(@"Index = %tu", [ICD10DiagnosisIndex MR_countOfEntities]);
    NSLog(@"EIndex = %tu", [ICD10DiagnosisEIndex MR_countOfEntities]);
}

#pragma mark - Tabular methods
- (void) loadICD10Tabular
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
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Tabular.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//chapter" inParser:parser])
    {
        ICD10Diagnosis *chapter = [ICD10Diagnosis MR_createEntity];
        NSMutableOrderedSet *setSections = [[NSMutableOrderedSet alloc] init];
        
        for (TFHppleElement *elemChapter in element.children)
        {
            if ([elemChapter.tagName isEqualToString:@"section"])
            {
                ICD10Diagnosis *section = [ICD10Diagnosis MR_createEntity];
                NSMutableOrderedSet *setDiags = [[NSMutableOrderedSet alloc] init];
                
                NSString *range = [elemChapter objectForKey:@"id"];
                NSArray *arrRange = [range componentsSeparatedByString: @"-"];
                section.first = [arrRange objectAtIndex:0];
                if (arrRange.count == 2)
                {
                    section.last = [arrRange objectAtIndex:1];
                }
                
                for (TFHppleElement *elemSection in elemChapter.children)
                {
                    if ([elemSection.tagName isEqualToString:@"desc"])
                    {
                        section.desc = [[elemSection firstChild] content];
                    }
                    else if ([elemSection.tagName isEqualToString:@"diag"])
                    {
                        [setDiags addObject:[self diagFromElement:elemSection]];
                    }
                }
                section.children = setDiags;
                section.version = ICD10_VERSION;
                
                [setSections addObject:section];
            }
            else
            {
                [self applyElementContent:elemChapter toDiagnosis:chapter];
            }
        }
        chapter.first = [[setSections objectAtIndex:0] first];
        chapter.last = [[setSections lastObject] first];
        chapter.children = setSections;
        chapter.version = ICD10_VERSION;
        
        [currentContext MR_save];
    }
}

- (void) applyElementContent:(TFHppleElement*) element toDiagnosis:(ICD10Diagnosis*) diag
{
    NSString *content = [[element firstChild] content];
    
    if ([element.tagName isEqualToString:@"name"])
    {
        diag.name = content;
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:diag.name];
        int intVal = number ? [number intValue] : -1;
        
        if  (intVal >= 0 && intVal <= _arrShortNames.count)
        {
            NSDictionary *shortName = [_arrShortNames objectAtIndex:intVal-1];
            diag.first = [[[shortName allValues] objectAtIndex:0] objectAtIndex:0];
            diag.last = [[[shortName allValues] objectAtIndex:0] objectAtIndex:1];
            diag.shortName = [[shortName allKeys] objectAtIndex:0];
        }
    }
    else if ([element.tagName isEqualToString:@"desc"])
    {
        diag.desc = content;
    }
    else if ([element.tagName isEqualToString:@"includes"])
    {
        diag.includes = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"inclusionTerm"])
    {
        diag.inclusionTerm = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"codeFirst"])
    {
        diag.codeFirst = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"codeAlso"])
    {
        diag.codeFirst = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"useAdditionalCode"])
    {
        diag.useAdditionalCode = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"excludes1"])
    {
        diag.excludes1 = [self notesFromElement:element];
    }
    else if ([element.tagName isEqualToString:@"excludes2"])
    {
        diag.excludes2 = [self notesFromElement:element];
    }
}

- (NSString*) notesFromElement:(TFHppleElement*) element
{
    NSMutableString *buffer = [[NSMutableString alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"note"])
        {
            [buffer appendString:[[child firstChild] content]];
            [buffer appendString:NOTES_SEPARATOR];
        }
    }
    
    // remove the trailing NOTES_SEPARATOR
    return [buffer substringToIndex:buffer.length-3];
}

- (ICD10Diagnosis*) diagFromElement:(TFHppleElement*) element
{
    ICD10Diagnosis *diag = [ICD10Diagnosis MR_createEntity];
    NSMutableOrderedSet *setDiags = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"diag"])
        {
            [setDiags addObject:[self diagFromElement:child]];
        }
        else
        {
            [self applyElementContent:child toDiagnosis:diag];
        }
    }
    
    diag.children = setDiags;
    diag.version = ICD10_VERSION;

    return diag;
}

#pragma mark - Neoplasm methods
- (void) loadICD10Neoplasm
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Neoplasm.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        ICD10DiagnosisNeoplasm *neo = [self neoplasmFromElement:element];
        [currentContext MR_save];
    }
}

- (ICD10DiagnosisNeoplasm*) neoplasmFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisNeoplasm *neo = [ICD10DiagnosisNeoplasm MR_createEntity];
    NSMutableOrderedSet *setNeos = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            [setNeos addObject:[self neoplasmFromElement:child]];
        }
        else if ([child.tagName isEqualToString:@"title"])
        {
            neo.title = content;
        }
        else if ([child.tagName isEqualToString:@"seeAlso"])
        {
            neo.seeAlso = content;
        }
        else if ([child.tagName isEqualToString:@"cell"])
        {
            if ([[child objectForKey:@"col"] isEqualToString:@"2"])
            {
                neo.malignantPrimary = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"3"])
            {
                neo.malignantSecondary = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"4"])
            {
                neo.caInSitu = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"5"])
            {
                neo.benign = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"6"])
            {
                neo.uncertainBehavior = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"7"])
            {
                neo.unspecifiedBehavior = content;
            }
        }
    }
    
    neo.children = setNeos;
    neo.version = ICD10_VERSION;
    
    return neo;
}

#pragma mark - Drug methods
- (void) loadICD10Drug
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Drug.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        ICD10DiagnosisDrug *drug = [self drugFromElement:element];
        [currentContext MR_save];
    }
}

- (ICD10DiagnosisDrug*) drugFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisDrug *drug = [ICD10DiagnosisDrug MR_createEntity];
    NSMutableOrderedSet *setDrugs = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            [setDrugs addObject:[self drugFromElement:child]];
        }
        else if ([child.tagName isEqualToString:@"title"])
        {
            drug.substance = content;
        }
        else if ([child.tagName isEqualToString:@"cell"])
        {
            if ([[child objectForKey:@"col"] isEqualToString:@"2"])
            {
                drug.poisoningAccidental = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"3"])
            {
                drug.poisoningIntentional = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"4"])
            {
                drug.poisoningAssault = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"5"])
            {
                drug.poisoningUndetermined = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"6"])
            {
                drug.adverseEffect = content;
            }
            else if ([[child objectForKey:@"col"] isEqualToString:@"7"])
            {
                drug.underdosing = content;
            }
        }
    }
    
    drug.children = setDrugs;
    drug.version = ICD10_VERSION;
    
    return drug;
}

#pragma mark - Index methods
- (void) loadICD10Index
{
    
}

#pragma mark - EIndex methods
- (void) loadICD10EIndex
{
    
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

//
//  DiagnosesLoader.m
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DiagnosesLoader.h"
#import "Database.h"
#import "JJJ/JJJUtil.h"
#import "ICD10Diagnosis.h"
#import "ICD10DiagnosisDrug.h"
#import "ICD10DiagnosisEIndex.h"
#import "ICD10DiagnosisIndex.h"
#import "ICD10DiagnosisNeoplasm.h"
#import "TFHpple.h"

@interface DiagnosesLoader()
{
//    NSArray  *_arrShortNames;
}
@end

@implementation DiagnosesLoader

- (void) loadDiagnoses
{
    NSDate *dateStart = [NSDate date];
    [[Database sharedInstance] setupDb];

//    NSUInteger count = [ICD10Diagnosis MR_countOfEntities];
//    if (count == 0)
//    {
//        [self loadICD10Tabular];
//    }
//    
//    count = [ICD10DiagnosisNeoplasm MR_countOfEntities];
//    if (count == 0)
//    {
//        [self loadICD10Neoplasm];
//    }
//    
//    count = [ICD10DiagnosisDrug MR_countOfEntities];
//    if (count == 0)
//    {
//        [self loadICD10Drug];
//    }
//    
//    count = [ICD10DiagnosisIndex MR_countOfEntities];
//    if (count == 0)
//    {
//        [self loadICD10Index];
//    }
//    
//    count = [ICD10DiagnosisEIndex MR_countOfEntities];
//    if (count == 0)
//    {
//        [self loadICD10EIndex];
//    }
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
//    NSLog(@"Tabular = %tu", [ICD10Diagnosis MR_countOfEntities]);
//    NSLog(@"Neoplasm = %tu", [ICD10DiagnosisNeoplasm MR_countOfEntities]);
//    NSLog(@"Drug = %tu", [ICD10DiagnosisDrug MR_countOfEntities]);
//    NSLog(@"Index = %tu", [ICD10DiagnosisIndex MR_countOfEntities]);
//    NSLog(@"EIndex = %tu", [ICD10DiagnosisEIndex MR_countOfEntities]);
    
    [[Database sharedInstance ] closeDb];
}

#pragma mark - Tabular methods
- (void) loadICD10Tabular
{
//    _arrShortNames = @[@{@"Infectious"            : @[@"A00", @"B99"]},
//                       @{@"Neoplasms"             : @[@"C00", @"D49"]},
//                       @{@"Blood | Immune"        : @[@"D50", @"D89"]},
//                       @{@"Endo | Nutrit | Metab" : @[@"E00", @"E89"]},
//                       @{@"Mental | Behavioral"   : @[@"F01", @"F99"]},
//                       @{@"Nervous System"        : @[@"G00", @"G99"]},
//                       @{@"Eye | Adnexa"          : @[@"H00", @"H59"]},
//                       @{@"Ear | Mastoid"         : @[@"H60", @"H95"]},
//                       @{@"Circulatory"           : @[@"I00", @"I99"]},
//                       @{@"Respiratory"           : @[@"J00", @"J99"]},
//                       @{@"Digestive"             : @[@"K00", @"K95"]},
//                       @{@"Skin | Subcutaneous"   : @[@"L00", @"L99"]},
//                       @{@"Musculoskeletal"       : @[@"M00", @"M99"]},
//                       @{@"Genetourinary"         : @[@"N00", @"N99"]},
//                       @{@"Pregnancy | Childbirth": @[@"O00", @"O9A"]},
//                       @{@"Perinatal"             : @[@"P00", @"P96"]},
//                       @{@"Congenital"            : @[@"Q00", @"Q99"]},
//                       @{@"Symp | Signs | Labs"   : @[@"R00", @"R99"]},
//                       @{@"Injury | Poisoning"    : @[@"S00", @"T88"]},
//                       @{@"External Causes"       : @[@"V00", @"Y99"]},
//                       @{@"Factors | Reasons"     : @[@"Z00", @"Z99"]}];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Tabular.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//chapter" inParser:parser])
    {
        ICD10Diagnosis *chapter = nil; //[ICD10Diagnosis MR_createEntity];
        NSMutableOrderedSet *setSections = [[NSMutableOrderedSet alloc] init];
        
        for (TFHppleElement *elemChapter in element.children)
        {
            if ([elemChapter.tagName isEqualToString:@"section"])
            {
                ICD10Diagnosis *section = nil; //[ICD10Diagnosis MR_createEntity];
                NSMutableOrderedSet *setDiags = [[NSMutableOrderedSet alloc] init];
                
                NSString *range = [elemChapter objectForKey:@"id"];
                NSArray *arrRange = [range componentsSeparatedByString: @"-"];
                section.first = [arrRange firstObject];
                if (arrRange.count == 2)
                {
                    section.last = [arrRange lastObject];
                }
                
                section.parent = chapter;
                
                for (TFHppleElement *elemSection in elemChapter.children)
                {
                    if ([elemSection.tagName isEqualToString:@"desc"])
                    {
                        section.desc = [[elemSection firstChild] content];
                    }
                    else if ([elemSection.tagName isEqualToString:@"diag"])
                    {
                        ICD10Diagnosis *sub = [self diagFromElement:elemSection];
                        sub.parent = section;
                        [setDiags addObject:sub];
                    }
                }
                section.children = setDiags;
                section.version = ICD10_VERSION;
                NSRange range1 = [section.desc rangeOfString:@"(" options:NSBackwardsSearch];
                if (range1.location != NSNotFound)
                {
                    NSString *name = [section.desc substringFromIndex:range1.location+1];
                    section.name = [name substringToIndex:name.length-1];
                    
                    NSString *desc = [section.desc substringToIndex:range1.location-1];
                    section.desc = desc;
                }
                
                [setSections addObject:section];
            }
            else
            {
                [self applyElementContent:elemChapter toDiagnosis:chapter];
            }
        }
        
        chapter.first = [[setSections firstObject] first];
        chapter.last = [[setSections lastObject] first];
        chapter.children = setSections;
        chapter.version = ICD10_VERSION;
        NSRange range2 = [chapter.desc rangeOfString:@"(" options:NSBackwardsSearch];
        if (range2.location != NSNotFound)
        {
            NSString *name = [chapter.desc substringFromIndex:range2.location+1];
            chapter.name = [name substringToIndex:name.length-1];
            
            NSString *desc = [chapter.desc substringToIndex:range2.location-1];
            chapter.desc = desc;
        }
//        [currentContext MR_save];
    }
}

- (void) applyElementContent:(TFHppleElement*) element toDiagnosis:(ICD10Diagnosis*) diag
{
    NSString *content = [[element firstChild] content];
    
    if ([element.tagName isEqualToString:@"name"])
    {
        diag.name = content;
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
            [buffer appendFormat:@"%@%@", [[child firstChild] content], NOTES_SEPARATOR];
        }
    }
    
    // remove the trailing NOTES_SEPARATOR
    return [buffer substringToIndex:buffer.length-3];
}

- (ICD10Diagnosis*) diagFromElement:(TFHppleElement*) element
{
    ICD10Diagnosis *diag = nil; //[ICD10Diagnosis MR_createEntity];
    NSMutableOrderedSet *setDiags = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        if ([child.tagName isEqualToString:@"diag"])
        {
            ICD10Diagnosis *sub = [self diagFromElement:child];
            sub.parent = diag;
            [setDiags addObject:sub];
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
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        [self neoplasmFromElement:element];
//        [currentContext MR_save];
    }
}

- (ICD10DiagnosisNeoplasm*) neoplasmFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisNeoplasm *neo = nil; //[ICD10DiagnosisNeoplasm MR_createEntity];
    NSMutableOrderedSet *setNeos = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            ICD10DiagnosisNeoplasm *sub = [self neoplasmFromElement:child];
            sub.parent = neo;
            [setNeos addObject:sub];
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
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        [self drugFromElement:element];
//        [currentContext MR_save];
    }
}

- (ICD10DiagnosisDrug*) drugFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisDrug *drug = nil; //[ICD10DiagnosisDrug MR_createEntity];
    NSMutableOrderedSet *setDrugs = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            ICD10DiagnosisDrug *sub = [self drugFromElement:child];
            sub.parent = drug;
            [setDrugs addObject:sub];
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
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Index.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        [self indexFromElement:element];
//        [currentContext MR_save];
    }
}

- (ICD10DiagnosisIndex*) indexFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisIndex *index = nil; //[ICD10DiagnosisIndex MR_createEntity];
    NSMutableOrderedSet *setIndexes = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            ICD10DiagnosisIndex *sub = [self indexFromElement:child];
            sub.parent = index;
            [setIndexes addObject:sub];
        }
        else if ([child.tagName isEqualToString:@"title"])
        {
            
            if (child.hasChildren)
            {
                NSMutableString *buffer = [[NSMutableString alloc] init];
                
                if (content)
                {
                    [buffer appendString:content];
                }
                for (TFHppleElement *child2 in child.children)
                {
                    if ([child2.tagName isEqualToString:@"nemod"])
                    {
                        [buffer appendFormat:@" %@", [[child2 firstChild] content]];
                    }
                }
                
                index.title = buffer;
            }
            else
            {
                index.title = content;
            }
            
            if ([JJJUtil isAlphaStart:index.title])
            {
                index.titleInitial = [[index.title substringToIndex:1] uppercaseString];
            }
            else
            {
                index.titleInitial = @"#";
            }
        }
        else if ([child.tagName isEqualToString:@"code"])
        {
            index.code = content;
        }
        else if ([child.tagName isEqualToString:@"see"])
        {
            index.see = content;
        }
        else if ([child.tagName isEqualToString:@"seeAlso"])
        {
            index.seeAlso = content;
        }
    }
    
    index.children = setIndexes;
    index.version = ICD10_VERSION;
    
    return index;
}

#pragma mark - EIndex methods
- (void) loadICD10EIndex
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/E-Index.xml"];
    TFHpple *parser = [self parseFile:path];
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
    for (TFHppleElement *element in [self elementsWithPath:@"//letter/mainTerm" inParser:parser])
    {
        [self eIndexFromElement:element];
//        [currentContext MR_save];
    }
}

- (ICD10DiagnosisEIndex*) eIndexFromElement:(TFHppleElement*) element
{
    ICD10DiagnosisEIndex *index = nil; //[ICD10DiagnosisEIndex MR_createEntity];
    NSMutableOrderedSet *setIndexes = [[NSMutableOrderedSet alloc] init];
    
    for (TFHppleElement *child in element.children)
    {
        NSString *content = [[child firstChild] content];
        
        if ([child.tagName isEqualToString:@"term"])
        {
            ICD10DiagnosisEIndex *sub = [self eIndexFromElement:child];
            sub.parent = index;
            [setIndexes addObject:sub];
        }
        else if ([child.tagName isEqualToString:@"title"])
        {
            
            if (child.hasChildren)
            {
                NSMutableString *buffer = [[NSMutableString alloc] init];
                
                if (content)
                {
                    [buffer appendString:content];
                }
                for (TFHppleElement *child2 in child.children)
                {
                    if ([child2.tagName isEqualToString:@"nemod"])
                    {
                        [buffer appendFormat:@" %@", [[child2 firstChild] content]];
                    }
                }
                
                index.title = buffer;
            }
            else
            {
                index.title = content;
            }
            
            if ([JJJUtil isAlphaStart:index.title])
            {
                index.titleInitial = [[index.title substringToIndex:1] uppercaseString];
            }
            else
            {
                index.titleInitial = @"#";
            }
        }
        else if ([child.tagName isEqualToString:@"code"])
        {
            index.code = content;
        }
        else if ([child.tagName isEqualToString:@"see"])
        {
            index.see = content;
        }
        else if ([child.tagName isEqualToString:@"seeAlso"])
        {
            index.seeAlso = content;
        }
    }
    
    index.children = setIndexes;
    index.version = ICD10_VERSION;
    
    return index;
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

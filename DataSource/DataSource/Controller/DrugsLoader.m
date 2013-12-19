//
//  DrugsLoader.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DrugsLoader.h"

@implementation DrugsLoader
{
    Database *_database;
}

-(id) init
{
    if (self = [super init])
    {
        _database = [Database sharedInstance];
    }
    
    return self;
}

-(void) loadDrugs
{
    if ([_database tableCount:@"ChemicalType_Lookup"] == 0)
    {
        [self loadChemicalType_Lookup];
    }
    NSLog(@"ChemicalType_Lookup = %d", [_database tableCount:@"ChemicalType_Lookup"]);
    
    if ([_database tableCount:@"ReviewClass_Lookup"] == 0)
    {
        [self loadReviewClass_Lookup];
    }
    NSLog(@"ReviewClass_Lookup = %d", [_database tableCount:@"ReviewClass_Lookup"]);
    
    if ([_database tableCount:@"Application"] == 0)
    {
        [self loadApplication];
    }
    NSLog(@"Application = %d", [_database tableCount:@"Application"]);
    
    if ([_database tableCount:@"Product"] == 0)
    {
        [self loadProduct];
    }
    NSLog(@"Product = %d", [_database tableCount:@"Product"]);
    
    if ([_database tableCount:@"Product_TECode"] == 0)
    {
        [self loadProductTECode];
    }
    NSLog(@"Product_TECode = %d", [_database tableCount:@"Product_TECode"]);
    
    if ([_database tableCount:@"AppDocType_Lookup"] == 0)
    {
        [self loadAppDocType_Lookup];
    }
    NSLog(@"AppDocType_Lookup = %d", [_database tableCount:@"AppDocType_Lookup"]);
    
    if ([_database tableCount:@"AppDoc"] == 0)
    {
        [self loadAppDoc];
    }
    NSLog(@"AppDoc = %d", [_database tableCount:@"AppDoc"]);
    
    if ([_database tableCount:@"DocType_Lookup"] == 0)
    {
        [self loadDocType_Lookup];
    }
    NSLog(@"DocType_Lookup = %d", [_database tableCount:@"DocType_Lookup"]);
    
    if ([_database tableCount:@"RegActionDate"] == 0)
    {
        [self loadRegActionDate];
    }
    NSLog(@"RegActionDate = %d", [_database tableCount:@"RegActionDate"]);
}

-(void) loadChemicalType_Lookup
{
    if ([_database bIsTableEmpty:@"ChemicalType_Lookup"])
    {
        NSError *error;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"ChemTypeLookup"
//                                                         ofType:@"txt"
//                                                    inDirectory:@"drugsatfda"];
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ChemTypeLookup.txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }
            
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading ChemicalType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            ChemicalType_Lookup *obj = [_database createManagedObject:@"ChemicalType_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.chemicalTypeID =  [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                obj.chemicalTypeCode = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 3)
            {
                obj.chemicalTypeDescription = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadReviewClass_Lookup
{
    if ([_database bIsTableEmpty:@"ReviewClass_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ReviewClass_Lookup" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading ReviewClass_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            ReviewClass_Lookup *obj = [_database createManagedObject:@"ReviewClass_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.reviewClassID =  [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                obj.reviewCode = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 3)
            {
                obj.longDescription = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.shortDescription_ = [[elements objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadApplication
{
    if ([_database bIsTableEmpty:@"Application"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"application" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Application...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            Application *obj = [_database createManagedObject:@"Application"];
            
            if (elements.count >= 1)
            {
                obj.applNo = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.applType = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 3)
            {
                obj.sponsorApplicant = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.mostRecentLabelAvailableFlag = [NSNumber numberWithBool:[[elements objectAtIndex:3] boolValue]];
            }
            if (elements.count >= 5)
            {
                obj.currentPatentFlag = [NSNumber numberWithBool:[[elements objectAtIndex:4] boolValue]];
            }
            if (elements.count >= 6)
            {
                obj.actionType = [[elements objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 7 && [[elements objectAtIndex:6] length] > 0)
            {
                NSArray *array = [_database find:@"ChemicalType_Lookup"
                                      columnName:@"chemicalTypeID"
                                     columnValue:[elements objectAtIndex:6]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.chemicalType = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 8)
            {
                obj.therapeuticPotential = [[elements objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 9)
            {
                obj.orphanCode = [[elements objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadProduct
{
    if ([_database bIsTableEmpty:@"Product"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Product" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }
            
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Product...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            
            Product *obj = [_database createManagedObject:@"Product"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_database find:@"Application"
                                      columnName:@"applNo"
                                     columnValue:[elements objectAtIndex:0]
                                relationshipKeys:nil
                                         sorters:nil];
                if (array && array.count > 0)
                {
                    obj.applNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 2)
            {
                obj.productNo = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 3)
            {
                obj.form = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.dosage = [[elements objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 5)
            {
                obj.productMktStatus = [NSNumber numberWithInteger:[[elements objectAtIndex:4] integerValue]];
            }
            if (elements.count >= 6)
            {
                obj.teCode = [[elements objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 7)
            {
                obj.referenceDrug = [NSNumber numberWithInteger:[[elements objectAtIndex:6] integerValue]];
            }
            if (elements.count >= 8)
            {
                obj.drugName = [[elements objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 9)
            {
                obj.activeIngred = [[elements objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadProductTECode
{
    if ([_database bIsTableEmpty:@"Product_TECode"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Product_tecode" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Product_TECode...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            Product_TECode *obj = [_database createManagedObject:@"Product_TECode"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_database find:@"Application"
                                      columnName:@"applNo"
                                     columnValue:[elements objectAtIndex:0]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.applNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 2)
            {
                NSArray *array = [_database find:@"Product"
                                      columnName:@"productNo"
                                     columnValue:[elements objectAtIndex:1]
                                relationshipKeys:nil
                                         sorters:nil];
                if (array && array.count > 0)
                {
                    obj.productNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 3)
            {
                obj.teCode = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.teSequence = [NSNumber numberWithInteger:[[elements objectAtIndex:3] integerValue]];
            }
            if (elements.count >= 5)
            {
                obj.productMktStatus = [NSNumber numberWithInteger:[[elements objectAtIndex:4] integerValue]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadAppDocType_Lookup
{
    if ([_database bIsTableEmpty:@"AppDocType_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppDocType_Lookup" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading AppDocType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            AppDocType_Lookup *obj = [_database createManagedObject:@"AppDocType_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.appDocType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.sortOrder = [NSNumber numberWithInteger:[[elements objectAtIndex:1] integerValue]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadAppDoc
{
    if ([_database bIsTableEmpty:@"AppDoc"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppDoc" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSASCIIStringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading AppDoc...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            AppDoc *obj = [_database createManagedObject:@"AppDoc"];
            
            if (elements.count >= 1)
            {
                obj.appDocID = [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                NSArray *array = [_database find:@"Application"
                                      columnName:@"applNo"
                                     columnValue:[elements objectAtIndex:1]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.applNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 3)
            {
                obj.seqNo = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                NSArray *array = [_database find:@"AppDocType_Lookup"
                                      columnName:@"appDocType"
                                     columnValue:[elements objectAtIndex:3]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.docType = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 5)
            {
                obj.docTitle = [[elements objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 6)
            {
                obj.docURL = [[elements objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 7 && [[elements objectAtIndex:6] length] > 0)
            {
                obj.docDate = [formatter dateFromString:[elements objectAtIndex:6]];
            }
            if (elements.count >= 8)
            {
                obj.actionType = [[elements objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 9)
            {
                obj.duplicateCounter = [NSNumber numberWithInteger:[[elements objectAtIndex:8] integerValue]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
                break;
            }
            done++;
        }
    }
}

-(void) loadDocType_Lookup
{
    if ([_database bIsTableEmpty:@"DocType_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DocType_lookup" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading DocTypeLookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DocType_Lookup *obj = [_database createManagedObject:@"DocType_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.docType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.docTypeDesc = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadRegActionDate
{
    if ([_database bIsTableEmpty:@"RegActionDate"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RegActionDate" ofType:@"txt"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        BOOL bFirstLine = YES;

        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            if (bFirstLine)
            {
                bFirstLine = NO;
                continue;
            }

            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading RegActionDate...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            RegActionDate *obj = [_database createManagedObject:@"RegActionDate"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_database find:@"Application"
                                      columnName:@"applNo"
                                     columnValue:[elements objectAtIndex:0]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.applNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 2)
            {
                obj.actionType = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            if (elements.count >= 3)
            {
                obj.inDocTypeSeqNo = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.duplicateCounter = [[elements objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 5 && [[elements objectAtIndex:4] length] > 0)
            {
                obj.actionDate = [formatter dateFromString:[elements objectAtIndex:4]];
            }
            if (elements.count >= 6)
            {
                NSArray *array = [_database find:@"DocType_Lookup"
                                      columnName:@"docType"
                                     columnValue:[elements objectAtIndex:5]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.docType = [array objectAtIndex:0];
                }
            }
            
            NSError *error2;
            if (![[_database managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
                NSLog(@"%@", elements);
                break;
            }
            done++;
        }
    }
}

-(void) downloadDocuments
{
    NSArray *appDocs = [[Database sharedInstance] findAll:@"AppDoc" sorters:nil];
    int total = 0;
    
    for (AppDoc *appDoc in appDocs)
    {
        NSRange range = [appDoc.docURL rangeOfString:@"/" options:NSBackwardsSearch];
        NSString *fileName = [appDoc.docURL substringFromIndex:range.location+1];
        
        if ([self downloadFile:appDoc.docURL
                    destFolder:appDoc.docType.appDocType
                      destFile:fileName])
        {
            total++;
        }
    }
    
    NSLog(@"Finished downloading. total downloaded=%d", total);
}

-(BOOL) downloadFile:(NSString*) urlString destFolder:(NSString*)destFolder destFile:(NSString*)destFile
{
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *dir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], destFolder];
    NSString  *file = [NSString stringWithFormat:@"%@/%@", dir, destFile];
    
    // create directory if does not exist
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    // donut download file if it exists
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        //            NSError *error;
        //            [[NSFileManager defaultManager] removeItemAtPath:file error:&error];
        NSLog(@"Skipping... %@", urlString);
        return NO;
    }
    
    else
    {
        NSLog(@"Downloading... %@", urlString);
        NSURL  *url = [NSURL URLWithString:urlString];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if (urlData)
        {
            [urlData writeToFile:file atomically:YES];
            return YES;
        }
    }
    return NO;
}

@end

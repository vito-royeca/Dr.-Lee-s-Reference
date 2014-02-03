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
    JJJCoreData *_coreData;
}

-(id) init
{
    if (self = [super init])
    {
        _coreData = [JJJCoreData sharedInstanceWithModel:@"database"];
    }
    
    return self;
}

-(void) loadDrugs
{
    if ([_coreData tableCount:@"ChemicalType_Lookup"] == 0)
    {
        [self loadChemicalType_Lookup];
    }
    NSLog(@"ChemicalType_Lookup = %d", [_coreData tableCount:@"ChemicalType_Lookup"]);
    
    if ([_coreData tableCount:@"ReviewClass_Lookup"] == 0)
    {
        [self loadReviewClass_Lookup];
    }
    NSLog(@"ReviewClass_Lookup = %d", [_coreData tableCount:@"ReviewClass_Lookup"]);
    
    if ([_coreData tableCount:@"Application"] == 0)
    {
        [self loadApplication];
    }
    NSLog(@"Application = %d", [_coreData tableCount:@"Application"]);
    
    if ([_coreData tableCount:@"Product"] == 0)
    {
        [self loadProduct];
    }
    NSLog(@"Product = %d", [_coreData tableCount:@"Product"]);
    
    if ([_coreData tableCount:@"Product_TECode"] == 0)
    {
        [self loadProductTECode];
    }
    NSLog(@"Product_TECode = %d", [_coreData tableCount:@"Product_TECode"]);
    
    if ([_coreData tableCount:@"AppDocType_Lookup"] == 0)
    {
        [self loadAppDocType_Lookup];
    }
    NSLog(@"AppDocType_Lookup = %d", [_coreData tableCount:@"AppDocType_Lookup"]);
    
    if ([_coreData tableCount:@"AppDoc"] == 0)
    {
        [self loadAppDoc];
    }
    NSLog(@"AppDoc = %d", [_coreData tableCount:@"AppDoc"]);
    
    if ([_coreData tableCount:@"DocType_Lookup"] == 0)
    {
        [self loadDocType_Lookup];
    }
    NSLog(@"DocType_Lookup = %d", [_coreData tableCount:@"DocType_Lookup"]);
    
    if ([_coreData tableCount:@"RegActionDate"] == 0)
    {
        [self loadRegActionDate];
    }
    NSLog(@"RegActionDate = %d", [_coreData tableCount:@"RegActionDate"]);
}

-(void) loadChemicalType_Lookup
{
    if ([_coreData bIsTableEmpty:@"ChemicalType_Lookup"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/ChemTypeLookup.txt"];
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
            
            ChemicalType_Lookup *obj = [_coreData createManagedObject:@"ChemicalType_Lookup"];
            
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadReviewClass_Lookup
{
    if ([_coreData bIsTableEmpty:@"ReviewClass_Lookup"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/ReviewClass_Lookup.txt"];
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
            
            ReviewClass_Lookup *obj = [_coreData createManagedObject:@"ReviewClass_Lookup"];
            
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadApplication
{
    if ([_coreData bIsTableEmpty:@"Application"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/application.txt"];
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
            
            Application *obj = [_coreData createManagedObject:@"Application"];
            
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
                NSArray *array = [_coreData find:@"ChemicalType_Lookup"
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadProduct
{
    if ([_coreData bIsTableEmpty:@"Product"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Product.txt"];
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
            
            
            Product *obj = [_coreData createManagedObject:@"Product"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_coreData find:@"Application"
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadProductTECode
{
    if ([_coreData bIsTableEmpty:@"Product_TECode"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/Product_tecode.txt"];
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
            
            Product_TECode *obj = [_coreData createManagedObject:@"Product_TECode"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_coreData find:@"Application"
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
                NSArray *array = [_coreData find:@"Product"
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadAppDocType_Lookup
{
    if ([_coreData bIsTableEmpty:@"AppDocType_Lookup"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/AppDocType_Lookup.txt"];
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
            
            AppDocType_Lookup *obj = [_coreData createManagedObject:@"AppDocType_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.appDocType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.sortOrder = [NSNumber numberWithInteger:[[elements objectAtIndex:1] integerValue]];
            }
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadAppDoc
{
    if ([_coreData bIsTableEmpty:@"AppDoc"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/AppDoc.txt"];
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
            
            AppDoc *obj = [_coreData createManagedObject:@"AppDoc"];
            
            if (elements.count >= 1)
            {
                obj.appDocID = [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                NSArray *array = [_coreData find:@"Application"
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
                NSArray *array = [_coreData find:@"AppDocType_Lookup"
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
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadDocType_Lookup
{
    if ([_coreData bIsTableEmpty:@"DocType_Lookup"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/DocType_lookup.txt"];
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
            
            DocType_Lookup *obj = [_coreData createManagedObject:@"DocType_Lookup"];
            
            if (elements.count >= 1)
            {
                obj.docType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.docTypeDesc = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) loadRegActionDate
{
    if ([_coreData bIsTableEmpty:@"RegActionDate"])
    {
        NSError *error;
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Data/RegActionDate.txt"];
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
            
            RegActionDate *obj = [_coreData createManagedObject:@"RegActionDate"];
            
            if (elements.count >= 1)
            {
                NSArray *array = [_coreData find:@"Application"
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
                NSArray *array = [_coreData find:@"DocType_Lookup"
                                      columnName:@"docType"
                                     columnValue:[elements objectAtIndex:5]
                                relationshipKeys:nil
                                         sorters:nil];
                
                if (array && array.count > 0)
                {
                    obj.docType = [array objectAtIndex:0];
                }
            }
            
            if ([_coreData save])
            {
                done++;
            }
        }
    }
}

-(void) downloadDocuments
{
    NSArray *appDocs = [_coreData findAll:@"AppDoc" sorters:nil];
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

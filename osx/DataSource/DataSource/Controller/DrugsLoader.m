//
//  DrugsLoader.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DrugsLoader.h"
#import "JJJ/JJJUtil.h"
#import "DrugAppDoc.h"
#import "DrugAppDocType_Lookup.h"
#import "DrugApplication.h"
#import "DrugChemicalType_Lookup.h"
#import "DrugDocType_Lookup.h"
#import "FileDownloader.h"
#import "DrugProduct.h"
#import "DrugProduct_TECode.h"
#import "DrugRegActionDate.h"
#import "DrugReviewClass_Lookup.h"

@implementation DrugsLoader

-(void) loadDrugs
{
    NSDate *dateStart = [NSDate date];
//    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"database.sqlite"];
    
    NSUInteger count = nil; //[DrugChemicalType_Lookup MR_countOfEntities];
    if (count == 0)
    {
        [self loadChemicalType_Lookup];
    }
    
    count = nil; //[DrugReviewClass_Lookup MR_countOfEntities];
    if (count == 0)
    {
        [self loadReviewClass_Lookup];
    }
    
    count = nil; //[DrugApplication MR_countOfEntities];
    if (count == 0)
    {
        [self loadApplication];
    }
    
    count = nil; //[DrugProduct MR_countOfEntities];
    if (count == 0)
    {
        [self loadProduct];
    }
    
    count = nil; //[DrugProduct_TECode MR_countOfEntities];
    if (count == 0)
    {
        [self loadProductTECode];
    }
    
    count = nil; //[DrugAppDocType_Lookup MR_countOfEntities];
    if (count == 0)
    {
        [self loadAppDocType_Lookup];
    }
    
    count = nil; //[DrugAppDoc MR_countOfEntities];
    if (count == 0)
    {
        [self loadAppDoc];
    }
    
    count = nil; //[DrugDocType_Lookup MR_countOfEntities];
    if (count == 0)
    {
        [self loadDocType_Lookup];
    }
    
    count = nil; //[DrugRegActionDate MR_countOfEntities];
    if (count == 0)
    {
        [self loadRegActionDate];
    }
    
    NSDate *dateEnd = [NSDate date];
    NSTimeInterval timeDifference = [dateEnd timeIntervalSinceDate:dateStart];
    NSLog(@"Started: %@", dateStart);
    NSLog(@"Ended: %@", dateEnd);
    NSLog(@"Time Elapsed: %@",  [JJJUtil formatInterval:timeDifference]);
//    NSLog(@"DrugChemicalType_Lookup = %tu", [DrugChemicalType_Lookup MR_countOfEntities]);
//    NSLog(@"DrugReviewClass_Lookup = %tu", [DrugReviewClass_Lookup MR_countOfEntities]);
//    NSLog(@"DrugApplication = %tu", [DrugApplication MR_countOfEntities]);
//    NSLog(@"DrugProduct = %tu", [DrugProduct MR_countOfEntities]);
//    NSLog(@"DrugProduct_TECode = %tu", [DrugProduct_TECode MR_countOfEntities]);
//    NSLog(@"DrugAppDocType_Lookup = %tu", [DrugAppDocType_Lookup MR_countOfEntities]);
//    NSLog(@"DrugAppDoc = %tu", [DrugAppDoc MR_countOfEntities]);
//    NSLog(@"DrugDocType_Lookup = %tu", [DrugDocType_Lookup MR_countOfEntities]);
//    NSLog(@"DrugRegActionDate = %tu", [DrugRegActionDate MR_countOfEntities]);
}

-(void) loadChemicalType_Lookup
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
                NSLog(@"Loading DrugChemicalType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DrugChemicalType_Lookup *obj = nil; //[DrugChemicalType_Lookup MR_createInContext:currentContext];
            
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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadReviewClass_Lookup
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
                NSLog(@"Loading DrugReviewClass_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DrugReviewClass_Lookup *obj = nil; //[DrugReviewClass_Lookup MR_createInContext:currentContext];
            
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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadApplication
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
            
            DrugApplication *obj = nil; //[DrugApplication MR_createInContext:currentContext];
            
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
                NSArray *array = nil; //[DrugChemicalType_Lookup MR_findByAttribute:@"chemicalTypeID" withValue:[elements objectAtIndex:6]];
                
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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadProduct
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
            
            
            DrugProduct *obj = nil; //[DrugProduct MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                NSArray *array = nil; //[DrugApplication MR_findByAttribute:@"applNo" withValue:[elements objectAtIndex:0]];

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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadProductTECode
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
                NSLog(@"Loading DrugProduct_TECode...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DrugProduct_TECode *obj = nil; //[DrugProduct_TECode MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                NSArray *array = nil; //[DrugApplication MR_findByAttribute:@"applNo" withValue:[elements objectAtIndex:0]];
                
                if (array && array.count > 0)
                {
                    obj.applNo = [array objectAtIndex:0];
                }
            }
            if (elements.count >= 2)
            {
                NSArray *array = nil; //[DrugProduct MR_findByAttribute:@"productNo" withValue:[elements objectAtIndex:1]];
                
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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadAppDocType_Lookup
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
                NSLog(@"Loading DrugAppDocType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DrugAppDocType_Lookup *obj = nil; //[DrugAppDocType_Lookup MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                obj.appDocType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.sortOrder = [NSNumber numberWithInteger:[[elements objectAtIndex:1] integerValue]];
            }
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadAppDoc
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
            
            DrugAppDoc *obj = nil; //[DrugAppDoc MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                obj.appDocID = [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                NSArray *array = nil; //[DrugApplication MR_findByAttribute:@"applNo" withValue:[elements objectAtIndex:1]];
                
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
                NSArray *array = nil; //[DrugAppDocType_Lookup MR_findByAttribute:@"appDocType" withValue:[elements objectAtIndex:3]];
                
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
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadDocType_Lookup
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
                NSLog(@"Loading DrugDocTypeLookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DrugDocType_Lookup *obj = nil; //[DrugDocType_Lookup MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                obj.docType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.docTypeDesc = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) loadRegActionDate
{
    NSManagedObjectContext *currentContext = nil; //[NSManagedObjectContext MR_contextForCurrentThread];
    
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
            
            DrugRegActionDate *obj = nil; //[DrugRegActionDate MR_createInContext:currentContext];
            
            if (elements.count >= 1)
            {
                NSArray *array = nil; //[DrugApplication MR_findByAttribute:@"applNo" withValue:[elements objectAtIndex:0]];
                
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
                NSArray *array = nil; //[DrugDocType_Lookup MR_findByAttribute:@"docType" withValue:[elements objectAtIndex:5]];
                
                if (array && array.count > 0)
                {
                    obj.docType = [array objectAtIndex:0];
                }
            }
            
//            [currentContext MR_save];
            done++;
        }
}

-(void) downloadDocuments
{
    NSArray *appDocs = nil; //[DrugAppDoc MR_findAll];
    int total = 0;
    
    for (DrugAppDoc *appDoc in appDocs)
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

//
//  DataLoader.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/20/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DataLoader.h"
#import "AppDelegate.h"

@implementation DataLoader

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (id)sharedInstance
{
    static DataLoader *me = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] init];
    });
    return me;
}

- (id)init
{
    if (self = [super init])
    {
        self.persistentStoreCoordinator;
    }
    return self;
}

- (void)dealloc
{
    // Should never be called, but just here for clarity really.
}

-(void) loadData
{
    if ([self tableCount:@"ChemicalType_Lookup"] == 0)
    {
        [self loadChemicalType_Lookup];
    }
    NSLog(@"ChemicalType_Lookup = %d", [self tableCount:@"ChemicalType_Lookup"]);
    
    if ([self tableCount:@"ReviewClass_Lookup"] == 0)
    {
        [self loadReviewClass_Lookup];
    }
    NSLog(@"ReviewClass_Lookup = %d", [self tableCount:@"ReviewClass_Lookup"]);
    
    if ([self tableCount:@"Application"] == 0)
    {
        [self loadApplication];
    }
    NSLog(@"Application = %d", [self tableCount:@"Application"]);
    
    if ([self tableCount:@"Product"] == 0)
    {
        [self loadProduct];
    }
    NSLog(@"Product = %d", [self tableCount:@"Product"]);
    
    if ([self tableCount:@"Product_TECode"] == 0)
    {
        [self loadProductTECode];
    }
    NSLog(@"Product_TECode = %d", [self tableCount:@"Product_TECode"]);
    
    if ([self tableCount:@"AppDocType_Lookup"] == 0)
    {
        [self loadAppDocType_Lookup];
    }
    NSLog(@"AppDocType_Lookup = %d", [self tableCount:@"AppDocType_Lookup"]);
    
    if ([self tableCount:@"AppDoc"] == 0)
    {
        [self loadAppDoc];
    }
    NSLog(@"AppDoc = %d", [self tableCount:@"AppDoc"]);
    
    if ([self tableCount:@"DocType_Lookup"] == 0)
    {
        [self loadDocType_Lookup];
    }
    NSLog(@"DocType_Lookup = %d", [self tableCount:@"DocType_Lookup"]);
    
    if ([self tableCount:@"RegActionDate"] == 0)
    {
        [self loadRegActionDate];
    }
    NSLog(@"RegActionDate = %d", [self tableCount:@"RegActionDate"]);
}

- (BOOL) bIsTableEmpty:(NSString*)tableName
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count <= 0;
}

-(int) tableCount:(NSString*)tableName
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects.count;
}

-(id) objectByName:(NSString*)tableName andIdName:(NSString*)idName andIdValue:(id)idValue
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"%K == %@", idName, idValue];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects.count > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}

-(void) loadChemicalType_Lookup
{
    if ([self bIsTableEmpty:@"ChemicalType_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ChemTypeLookup" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading ChemicalType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            ChemicalType_Lookup *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ChemicalType_Lookup"
                                                                     inManagedObjectContext:[self managedObjectContext]];
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
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadReviewClass_Lookup
{
    if ([self bIsTableEmpty:@"ReviewClass_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ReviewClass_Lookup" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading ReviewClass_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            ReviewClass_Lookup *obj = [NSEntityDescription insertNewObjectForEntityForName:@"ReviewClass_Lookup"
                                                                    inManagedObjectContext:[self managedObjectContext]];
            
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
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadApplication
{
    if ([self bIsTableEmpty:@"Application"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"application" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Application...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            Application *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Application"
                                                             inManagedObjectContext:[self managedObjectContext]];
            
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
                obj.mostRecentLabelAvailableFlag = [[elements objectAtIndex:3] boolValue];
            }
            if (elements.count >= 5)
            {
                obj.currentPatentFlag = [[elements objectAtIndex:4] boolValue];
            }
            if (elements.count >= 6)
            {
                obj.actionType = [[elements objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 7 && [[elements objectAtIndex:6] length] > 0)
            {
                obj.chemicalType = [self objectByName:@"ChemicalType_Lookup"
                                            andIdName:@"chemicalTypeID"
                                           andIdValue:[elements objectAtIndex:6]];
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
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadProduct
{
    if ([self bIsTableEmpty:@"Product"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Product" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Product...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            
            Product *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Product"
                                                         inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.applNo = [self objectByName:@"Application"
                                      andIdName:@"applNo"
                                     andIdValue:[elements objectAtIndex:0]];
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
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadProductTECode
{
    if ([self bIsTableEmpty:@"Product_TECode"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Product_tecode" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading Product_TECode...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            Product_TECode *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Product_TECode"
                                                                inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.applNo = [self objectByName:@"Application"
                                      andIdName:@"applNo"
                                     andIdValue:[elements objectAtIndex:0]];
            }
            if (elements.count >= 2)
            {
                obj.productNo = [self objectByName:@"Product"
                                         andIdName:@"productNo"
                                        andIdValue:[elements objectAtIndex:1]];
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
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadAppDocType_Lookup
{
    if ([self bIsTableEmpty:@"AppDocType_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppDocType_Lookup" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading AppDocType_Lookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            AppDocType_Lookup *obj = [NSEntityDescription insertNewObjectForEntityForName:@"AppDocType_Lookup"
                                                                   inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.appDocType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.sortOrder = [NSNumber numberWithInteger:[[elements objectAtIndex:1] integerValue]];
            }
            
            NSError *error2;
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadAppDoc
{
    if ([self bIsTableEmpty:@"AppDoc"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppDoc" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSASCIIStringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
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
            
            AppDoc *obj = [NSEntityDescription insertNewObjectForEntityForName:@"AppDoc"
                                                        inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.appDocID = [NSNumber numberWithInteger:[[elements objectAtIndex:0] integerValue]];
            }
            if (elements.count >= 2)
            {
                obj.applNo = [self objectByName:@"Application"
                                      andIdName:@"applNo"
                                     andIdValue:[elements objectAtIndex:1]];
            }
            if (elements.count >= 3)
            {
                obj.seqNo = [[elements objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 4)
            {
                obj.docType = [self objectByName:@"AppDocType_Lookup"
                                       andIdName:@"appDocType"
                                      andIdValue:[elements objectAtIndex:3]];
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
            if (![[self managedObjectContext] save:&error2])
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
    if ([self bIsTableEmpty:@"DocType_Lookup"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DocType_lookup" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }
        
        for (NSString* line in allLines)
        {
            NSArray *elements = [line componentsSeparatedByString:@"\t"];
            
            if (elements.count <= 1)
            {
                continue;
            }
            if (done % (int)sentinel == 0)
            {
                NSLog(@"Loading DocTypeLookup...%d%%", (int)(((float)done/allLines.count)*100));
            }
            
            DocType_Lookup *obj = [NSEntityDescription insertNewObjectForEntityForName:@"DocType_Lookup"
                                                                inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.docType = [[elements objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if (elements.count >= 2)
            {
                obj.docTypeDesc = [[elements objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            NSError *error2;
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
            }
            done++;
        }
    }
}

-(void) loadRegActionDate
{
    if ([self bIsTableEmpty:@"RegActionDate"])
    {
        NSError *error;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"RegActionDate" ofType:@"csv"];
        NSString *file = [[NSString alloc] initWithContentsOfFile:path
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
        NSArray *allLines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        float sentinel = allLines.count/10;
        int done = 0;
        
        if (sentinel < 10)
        {
            sentinel = allLines.count;
        }

        for (NSString* line in allLines)
        {
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
            
            RegActionDate *obj = [NSEntityDescription insertNewObjectForEntityForName:@"RegActionDate"
                                                               inManagedObjectContext:[self managedObjectContext]];
            
            if (elements.count >= 1)
            {
                obj.applNo = [self objectByName:@"Application"
                                      andIdName:@"applNo"
                                     andIdValue:[elements objectAtIndex:0]];
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
                obj.docType = [self objectByName:@"DocType_Lookup"
                                       andIdName:@"docType"
                                      andIdValue:[elements objectAtIndex:5]];
            }
            
            NSError *error2;
            if (![[self managedObjectContext] save:&error2])
            {
                NSLog(@"Save error: %@", [error2 localizedDescription]);
                NSLog(@"%@", elements);
                break;
            }
            done++;
        }
    }
}

-(NSArray*) search:(NSString*)query
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[self managedObjectContext]];
    NSPredicate *predicate;
    NSMutableArray *arrDrugs = [[NSMutableArray  alloc] init];

    if (query.length == 0)
    {
        return arrDrugs;
    }
    else if (query.length == 1)
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K BEGINSWITH[cd] %@",
                     @"drugName", query];
    }
    else
    {
        predicate = [NSPredicate
                     predicateWithFormat:@"%K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@ OR %K CONTAINS[cd] %@",
                     @"drugName", query,
                     @"activeIngred", query,
                     @"applNo.sponsorApplicant", query];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"drugName" ascending:YES];
    
    NSArray *relationshipKeys = [NSArray arrayWithObject:@"applNo"];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeys];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    
    for (Product *p in fetchedObjects)
    {
        NSMutableDictionary *dict;
        
        for (NSMutableDictionary *d in arrDrugs)
        {
            if ([[d objectForKey:@"Drug Name"] isEqualToString:p.drugName])
            {
                dict = d;
                break;
            }
        }
        
        if (dict)
        {
            NSMutableArray *drugs = [dict objectForKey:@"Products"];
            
            [drugs addObject:p];
        }
        else
        {
            dict = [[NSMutableDictionary alloc] init];
            NSMutableArray *drugs = [[NSMutableArray alloc] init];
            [drugs addObject:p];
            
            [dict setObject:p.drugName forKey:@"Drug Name"];
            [dict setObject:p.activeIngred forKey:@"Active Ingredient"];
            [dict setObject:drugs forKey:@"Products"];
            [arrDrugs addObject:dict];
        }
    }
    
    return arrDrugs;
}

-(NSArray*) searchAllDrugs
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:[self managedObjectContext]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"drugName" ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"database.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"database" ofType:@"sqlite"]];
        
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err])
        {
            NSLog(@"Oops, could copy preloaded data");
        }
    }
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

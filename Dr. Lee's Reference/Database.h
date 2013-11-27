//
//  DataLoader.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/20/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppDoc.h"
#import "AppDocType_Lookup.h"
#import "Application.h"
#import "ChemicalType_Lookup.h"
#import "DocType_Lookup.h"
#import "Product.h"
#import "Product_TECode.h"
#import "RegActionDate.h"
#import "ReviewClass_Lookup.h"
#import "Util.h"

@interface Database : NSObject

+ (id)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


-(BOOL) bIsTableEmpty:(NSString*)tableName;
-(int) tableCount:(NSString*)tableName;
-(NSArray*) find:(NSString*)tableName
      columnName:(NSString*)columnName
     columnValue:(id)columnValue
relationshipKeys:(NSArray*)relationshipKeys
         sorters:(NSArray*)sorters;

-(NSArray*) searchDrugs:(NSString*)query;
-(NSArray*) searchAllDrugs;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

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

@interface DataLoader : NSObject

+ (id)sharedInstance;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void) loadData;
-(BOOL) bIsTableEmpty:(NSString*)tableName;
-(int) tableCount:(NSString*)tableName;
-(id) objectByName:(NSString*)tableName andIdName:(NSString*)idName andIdValue:(id)idValue;
-(void) loadChemicalType_Lookup;
-(void) loadReviewClass_Lookup;
-(void) loadApplication;
-(void) loadProduct;
-(void) loadProductTECode;
-(void) loadAppDocType_Lookup;
-(void) loadAppDoc;
-(void) loadDocType_Lookup;
-(void) loadRegActionDate;

-(NSArray*) search:(NSString*)query;
-(NSArray*) searchAllDrugs;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

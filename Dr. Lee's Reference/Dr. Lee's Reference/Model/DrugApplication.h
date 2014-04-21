//
//  DrugApplication.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugAppDoc, DrugChemicalType_Lookup, DrugProduct, DrugProduct_TECode, DrugRegActionDate;

@interface DrugApplication : NSManagedObject

@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * applNo;
@property (nonatomic, retain) NSString * applType;
@property (nonatomic, retain) NSNumber * currentPatentFlag;
@property (nonatomic, retain) NSNumber * mostRecentLabelAvailableFlag;
@property (nonatomic, retain) NSString * orphanCode;
@property (nonatomic, retain) NSString * sponsorApplicant;
@property (nonatomic, retain) NSString * therapeuticPotential;
@property (nonatomic, retain) NSSet *appDocId;
@property (nonatomic, retain) DrugChemicalType_Lookup *chemicalType;
@property (nonatomic, retain) NSSet *product;
@property (nonatomic, retain) NSSet *product_teCode;
@property (nonatomic, retain) NSSet *regActionDate;
@end

@interface DrugApplication (CoreDataGeneratedAccessors)

- (void)addAppDocIdObject:(DrugAppDoc *)value;
- (void)removeAppDocIdObject:(DrugAppDoc *)value;
- (void)addAppDocId:(NSSet *)values;
- (void)removeAppDocId:(NSSet *)values;

- (void)addProductObject:(DrugProduct *)value;
- (void)removeProductObject:(DrugProduct *)value;
- (void)addProduct:(NSSet *)values;
- (void)removeProduct:(NSSet *)values;

- (void)addProduct_teCodeObject:(DrugProduct_TECode *)value;
- (void)removeProduct_teCodeObject:(DrugProduct_TECode *)value;
- (void)addProduct_teCode:(NSSet *)values;
- (void)removeProduct_teCode:(NSSet *)values;

- (void)addRegActionDateObject:(DrugRegActionDate *)value;
- (void)removeRegActionDateObject:(DrugRegActionDate *)value;
- (void)addRegActionDate:(NSSet *)values;
- (void)removeRegActionDate:(NSSet *)values;

@end

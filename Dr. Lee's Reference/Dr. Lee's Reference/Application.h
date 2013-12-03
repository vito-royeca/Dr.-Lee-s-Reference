//
//  Application.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDoc, ChemicalType_Lookup, Product, Product_TECode, RegActionDate;

@interface Application : NSManagedObject

@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * applNo;
@property (nonatomic, retain) NSString * applType;
@property (nonatomic, retain) NSNumber * currentPatentFlag;
@property (nonatomic, retain) NSNumber * mostRecentLabelAvailableFlag;
@property (nonatomic, retain) NSString * orphanCode;
@property (nonatomic, retain) NSString * sponsorApplicant;
@property (nonatomic, retain) NSString * therapeuticPotential;
@property (nonatomic, retain) NSSet *appDocId;
@property (nonatomic, retain) ChemicalType_Lookup *chemicalType;
@property (nonatomic, retain) NSSet *product;
@property (nonatomic, retain) NSSet *product_teCode;
@property (nonatomic, retain) NSSet *regActionDate;

-(NSString*) applTypeString;
@end

@interface Application (CoreDataGeneratedAccessors)

- (void)addAppDocIdObject:(AppDoc *)value;
- (void)removeAppDocIdObject:(AppDoc *)value;
- (void)addAppDocId:(NSSet *)values;
- (void)removeAppDocId:(NSSet *)values;

- (void)addProductObject:(Product *)value;
- (void)removeProductObject:(Product *)value;
- (void)addProduct:(NSSet *)values;
- (void)removeProduct:(NSSet *)values;

- (void)addProduct_teCodeObject:(Product_TECode *)value;
- (void)removeProduct_teCodeObject:(Product_TECode *)value;
- (void)addProduct_teCode:(NSSet *)values;
- (void)removeProduct_teCode:(NSSet *)values;

- (void)addRegActionDateObject:(RegActionDate *)value;
- (void)removeRegActionDateObject:(RegActionDate *)value;
- (void)addRegActionDate:(NSSet *)values;
- (void)removeRegActionDate:(NSSet *)values;

@end

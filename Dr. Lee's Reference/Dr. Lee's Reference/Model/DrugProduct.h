//
//  DrugProduct.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugApplication, DrugProduct_TECode;

@interface DrugProduct : NSManagedObject

@property (nonatomic, retain) NSString * activeIngred;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSString * drugName;
@property (nonatomic, retain) NSString * form;
@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) NSString * productNo;
@property (nonatomic, retain) NSNumber * referenceDrug;
@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) DrugApplication *applNo;
@property (nonatomic, retain) NSSet *product_teCode;

-(NSString*) productMktStatusString;
-(NSString*) referenceDrugString;

@end

@interface DrugProduct (CoreDataGeneratedAccessors)

- (void)addProduct_teCodeObject:(DrugProduct_TECode *)value;
- (void)removeProduct_teCodeObject:(DrugProduct_TECode *)value;
- (void)addProduct_teCode:(NSSet *)values;
- (void)removeProduct_teCode:(NSSet *)values;

@end

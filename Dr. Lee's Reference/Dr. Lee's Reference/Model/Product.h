//
//  Product.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application, Product_TECode;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * activeIngred;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSString * drugName;
@property (nonatomic, retain) NSString * form;
@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) NSString * productNo;
@property (nonatomic, retain) NSNumber * referenceDrug;
@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) Application *applNo;
@property (nonatomic, retain) NSSet *product_teCode;

-(NSString*) productMktStatusString;
-(NSString*) referenceDrugString;

@end

@interface Product (CoreDataGeneratedAccessors)

- (void)addProduct_teCodeObject:(Product_TECode *)value;
- (void)removeProduct_teCodeObject:(Product_TECode *)value;
- (void)addProduct_teCode:(NSSet *)values;
- (void)removeProduct_teCode:(NSSet *)values;

@end

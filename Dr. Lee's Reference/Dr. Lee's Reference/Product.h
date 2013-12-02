//
//  Product.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//#define product_mkt_status(x) (switch ((x)) case 1: (@"Prescription") \
//                                            case 2: (@"OTC") \
//                                            case 3: (@"Discontinued") \
//                                            case 4: (@"Tentative Approval"))

@class Application;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * productNo;
@property (nonatomic, retain) NSString * form;
@property (nonatomic, retain) NSString * dosage;
@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) NSNumber * referenceDrug;
@property (nonatomic, retain) NSString * drugName;
@property (nonatomic, retain) NSString * activeIngred;
@property (nonatomic, retain) Application *applNo;

-(NSString*) productMktStatusString;
-(NSString*) referenceDrugString;

@end

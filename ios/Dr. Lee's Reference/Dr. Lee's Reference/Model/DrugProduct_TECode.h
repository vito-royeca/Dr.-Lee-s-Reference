//
//  DrugProduct_TECode.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugApplication, DrugProduct;

@interface DrugProduct_TECode : NSManagedObject

@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) NSNumber * teSequence;
@property (nonatomic, retain) DrugApplication *applNo;
@property (nonatomic, retain) DrugProduct *productNo;

@end

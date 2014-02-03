//
//  Product_TECode.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application, Product;

@interface Product_TECode : NSManagedObject

@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) NSNumber * teSequence;
@property (nonatomic, retain) Application *applNo;
@property (nonatomic, retain) Product *productNo;

@end

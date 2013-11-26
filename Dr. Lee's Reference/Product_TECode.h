//
//  Product_TECode.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application, Product;

@interface Product_TECode : NSManagedObject

@property (nonatomic, retain) NSString * teCode;
@property (nonatomic, retain) NSNumber * teSequence;
@property (nonatomic, retain) NSNumber * productMktStatus;
@property (nonatomic, retain) Application *applNo;
@property (nonatomic, retain) Product *productNo;

@end

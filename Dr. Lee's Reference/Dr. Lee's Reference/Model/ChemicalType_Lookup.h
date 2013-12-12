//
//  ChemicalType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application;

@interface ChemicalType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * chemicalTypeCode;
@property (nonatomic, retain) NSString * chemicalTypeDescription;
@property (nonatomic, retain) NSNumber * chemicalTypeID;
@property (nonatomic, retain) NSSet *applNo;
@end

@interface ChemicalType_Lookup (CoreDataGeneratedAccessors)

- (void)addApplNoObject:(Application *)value;
- (void)removeApplNoObject:(Application *)value;
- (void)addApplNo:(NSSet *)values;
- (void)removeApplNo:(NSSet *)values;

@end

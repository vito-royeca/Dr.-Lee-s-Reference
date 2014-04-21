//
//  DrugChemicalType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugApplication;

@interface DrugChemicalType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * chemicalTypeCode;
@property (nonatomic, retain) NSString * chemicalTypeDescription;
@property (nonatomic, retain) NSNumber * chemicalTypeID;
@property (nonatomic, retain) NSSet *applNo;
@end

@interface DrugChemicalType_Lookup (CoreDataGeneratedAccessors)

- (void)addApplNoObject:(DrugApplication *)value;
- (void)removeApplNoObject:(DrugApplication *)value;
- (void)addApplNo:(NSSet *)values;
- (void)removeApplNo:(NSSet *)values;

@end

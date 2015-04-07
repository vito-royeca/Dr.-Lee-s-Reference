//
//  DrugDocType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugRegActionDate;

@interface DrugDocType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * docType;
@property (nonatomic, retain) NSString * docTypeDesc;
@property (nonatomic, retain) NSSet *regActionDate;
@end

@interface DrugDocType_Lookup (CoreDataGeneratedAccessors)

- (void)addRegActionDateObject:(DrugRegActionDate *)value;
- (void)removeRegActionDateObject:(DrugRegActionDate *)value;
- (void)addRegActionDate:(NSSet *)values;
- (void)removeRegActionDate:(NSSet *)values;

@end

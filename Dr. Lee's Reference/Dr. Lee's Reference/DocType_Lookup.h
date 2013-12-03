//
//  DocType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RegActionDate;

@interface DocType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * docType;
@property (nonatomic, retain) NSString * docTypeDesc;
@property (nonatomic, retain) NSSet *regActionDate;
@end

@interface DocType_Lookup (CoreDataGeneratedAccessors)

- (void)addRegActionDateObject:(RegActionDate *)value;
- (void)removeRegActionDateObject:(RegActionDate *)value;
- (void)addRegActionDate:(NSSet *)values;
- (void)removeRegActionDate:(NSSet *)values;

@end

//
//  DrugAppDocType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugAppDoc;

@interface DrugAppDocType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * appDocType;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSSet *appDocID;
@end

@interface DrugAppDocType_Lookup (CoreDataGeneratedAccessors)

- (void)addAppDocIDObject:(DrugAppDoc *)value;
- (void)removeAppDocIDObject:(DrugAppDoc *)value;
- (void)addAppDocID:(NSSet *)values;
- (void)removeAppDocID:(NSSet *)values;

@end

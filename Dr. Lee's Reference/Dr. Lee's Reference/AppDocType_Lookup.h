//
//  AppDocType_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDoc;

@interface AppDocType_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * appDocType;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSSet *appDocID;
@end

@interface AppDocType_Lookup (CoreDataGeneratedAccessors)

- (void)addAppDocIDObject:(AppDoc *)value;
- (void)removeAppDocIDObject:(AppDoc *)value;
- (void)addAppDocID:(NSSet *)values;
- (void)removeAppDocID:(NSSet *)values;

@end

//
//  ICD10Procedure.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/26/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Procedure;

@interface ICD10Procedure : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * longName;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10Procedure *parent;
@end

@interface ICD10Procedure (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10Procedure *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10Procedure *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10Procedure *)value;
- (void)removeChildrenObject:(ICD10Procedure *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

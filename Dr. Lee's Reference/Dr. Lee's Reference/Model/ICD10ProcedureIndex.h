//
//  ICD10ProcedureIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Procedure, ICD10ProcedureIndex;

@interface ICD10ProcedureIndex : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) ICD10Procedure *procedure;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10ProcedureIndex *parent;
@property (nonatomic, retain) NSOrderedSet *see;
@property (nonatomic, retain) NSOrderedSet *use;
@end

@interface ICD10ProcedureIndex (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10ProcedureIndex *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10ProcedureIndex *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10ProcedureIndex *)value;
- (void)removeChildrenObject:(ICD10ProcedureIndex *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
- (void)insertObject:(ICD10ProcedureIndex *)value inSeeAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSeeAtIndex:(NSUInteger)idx;
- (void)insertSee:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSeeAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSeeAtIndex:(NSUInteger)idx withObject:(ICD10ProcedureIndex *)value;
- (void)replaceSeeAtIndexes:(NSIndexSet *)indexes withSee:(NSArray *)values;
- (void)addSeeObject:(ICD10ProcedureIndex *)value;
- (void)removeSeeObject:(ICD10ProcedureIndex *)value;
- (void)addSee:(NSOrderedSet *)values;
- (void)removeSee:(NSOrderedSet *)values;
- (void)insertObject:(ICD10ProcedureIndex *)value inUseAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUseAtIndex:(NSUInteger)idx;
- (void)insertUse:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUseAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUseAtIndex:(NSUInteger)idx withObject:(ICD10ProcedureIndex *)value;
- (void)replaceUseAtIndexes:(NSIndexSet *)indexes withUse:(NSArray *)values;
- (void)addUseObject:(ICD10ProcedureIndex *)value;
- (void)removeUseObject:(ICD10ProcedureIndex *)value;
- (void)addUse:(NSOrderedSet *)values;
- (void)removeUse:(NSOrderedSet *)values;
@end

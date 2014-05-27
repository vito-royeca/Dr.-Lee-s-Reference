//
//  ICD10ProcedureIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/27/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Procedure, ICD10ProcedureIndex;

@interface ICD10ProcedureIndex : NSManagedObject

@property (nonatomic, retain) NSString * see;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * use;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10Procedure *code;
@property (nonatomic, retain) ICD10ProcedureIndex *parent;
@property (nonatomic, retain) ICD10Procedure *seeCode;
@property (nonatomic, retain) ICD10Procedure *useCode;
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

//- (void)insertObject:(ICD10Procedure *)value inSeeCodeAtIndex:(NSUInteger)idx;
//- (void)removeObjectFromSeeCodeAtIndex:(NSUInteger)idx;
//- (void)insertSeeCode:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
//- (void)removeSeeCodeAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInSeeCodeAtIndex:(NSUInteger)idx withObject:(ICD10Procedure *)value;
//- (void)replaceSeeCodeAtIndexes:(NSIndexSet *)indexes withSeeCode:(NSArray *)values;
//- (void)addSeeCodeObject:(ICD10Procedure *)value;
//- (void)removeSeeCodeObject:(ICD10Procedure *)value;
//- (void)addSeeCode:(NSOrderedSet *)values;
//- (void)removeSeeCode:(NSOrderedSet *)values;
//
//- (void)insertObject:(ICD10Procedure *)value inUseCodeAtIndex:(NSUInteger)idx;
//- (void)removeObjectFromUseCodeAtIndex:(NSUInteger)idx;
//- (void)insertUseCode:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
//- (void)removeUseCodeAtIndexes:(NSIndexSet *)indexes;
//- (void)replaceObjectInUseCodeAtIndex:(NSUInteger)idx withObject:(ICD10Procedure *)value;
//- (void)replaceUseCodeAtIndexes:(NSIndexSet *)indexes withUseCode:(NSArray *)values;
//- (void)addUseCodeObject:(ICD10Procedure *)value;
//- (void)removeUseCodeObject:(ICD10Procedure *)value;
//- (void)addUseCode:(NSOrderedSet *)values;
//- (void)removeUseCode:(NSOrderedSet *)values;
@end

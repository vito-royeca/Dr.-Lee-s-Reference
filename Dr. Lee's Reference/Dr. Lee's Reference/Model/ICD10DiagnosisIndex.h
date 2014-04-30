//
//  ICD10DiagnosisIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10DiagnosisIndex;

@interface ICD10DiagnosisIndex : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * see;
@property (nonatomic, retain) NSString * seeAlso;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10DiagnosisIndex *parent;
@end

@interface ICD10DiagnosisIndex (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10DiagnosisIndex *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10DiagnosisIndex *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10DiagnosisIndex *)value;
- (void)removeChildrenObject:(ICD10DiagnosisIndex *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

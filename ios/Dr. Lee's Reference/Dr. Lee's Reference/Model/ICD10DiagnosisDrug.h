//
//  ICD10DiagnosisDrug.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10DiagnosisDrug;

@interface ICD10DiagnosisDrug : NSManagedObject

@property (nonatomic, retain) NSString * adverseEffect;
@property (nonatomic, retain) NSString * poisoningAccidental;
@property (nonatomic, retain) NSString * poisoningAssault;
@property (nonatomic, retain) NSString * poisoningIntentional;
@property (nonatomic, retain) NSString * poisoningUndetermined;
@property (nonatomic, retain) NSString * substance;
@property (nonatomic, retain) NSString * underdosing;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10DiagnosisDrug *parent;
@end

@interface ICD10DiagnosisDrug (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10DiagnosisDrug *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10DiagnosisDrug *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10DiagnosisDrug *)value;
- (void)removeChildrenObject:(ICD10DiagnosisDrug *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

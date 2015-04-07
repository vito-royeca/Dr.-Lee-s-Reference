//
//  ICD10DiagnosisEIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10DiagnosisEIndex;

@interface ICD10DiagnosisEIndex : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * see;
@property (nonatomic, retain) NSString * seeAlso;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10DiagnosisEIndex *parent;
@end

@interface ICD10DiagnosisEIndex (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10DiagnosisEIndex *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10DiagnosisEIndex *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10DiagnosisEIndex *)value;
- (void)removeChildrenObject:(ICD10DiagnosisEIndex *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

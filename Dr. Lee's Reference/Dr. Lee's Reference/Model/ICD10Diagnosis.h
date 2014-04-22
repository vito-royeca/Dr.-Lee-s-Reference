//
//  ICD10Diagnosis.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Diagnosis;

@interface ICD10Diagnosis : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * excludes1;
@property (nonatomic, retain) NSString * excludes2;
@property (nonatomic, retain) NSString * includes;
@property (nonatomic, retain) NSString * inclusionTerm;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSString * excludes;
@property (nonatomic, retain) NSString * codeFirst;
@property (nonatomic, retain) NSString * codeAlso;
@property (nonatomic, retain) NSString * useAdditionalCode;
@property (nonatomic, retain) NSString * first;
@property (nonatomic, retain) NSString * last;
@property (nonatomic, retain) ICD10Diagnosis *parent;
@property (nonatomic, retain) NSOrderedSet *children;
@end

@interface ICD10Diagnosis (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10Diagnosis *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10Diagnosis *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10Diagnosis *)value;
- (void)removeChildrenObject:(ICD10Diagnosis *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

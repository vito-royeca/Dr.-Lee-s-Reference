//
//  ICD10DiagnosisNeoplasm.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10DiagnosisNeoplasm;

@interface ICD10DiagnosisNeoplasm : NSManagedObject

@property (nonatomic, retain) NSString * benign;
@property (nonatomic, retain) NSString * caInSitu;
@property (nonatomic, retain) NSString * malignantPrimary;
@property (nonatomic, retain) NSString * malignantSecondary;
@property (nonatomic, retain) NSString * seeAlso;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uncertainBehavior;
@property (nonatomic, retain) NSString * unspecifiedBehavior;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10DiagnosisNeoplasm *parent;
@end

@interface ICD10DiagnosisNeoplasm (CoreDataGeneratedAccessors)

- (void)insertObject:(ICD10DiagnosisNeoplasm *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(ICD10DiagnosisNeoplasm *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(ICD10DiagnosisNeoplasm *)value;
- (void)removeChildrenObject:(ICD10DiagnosisNeoplasm *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end

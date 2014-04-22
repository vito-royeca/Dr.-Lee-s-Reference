//
//  ICD10DiagnosisDrug.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Diagnosis, ICD10DiagnosisDrug;

@interface ICD10DiagnosisDrug : NSManagedObject

@property (nonatomic, retain) NSString * substance;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) ICD10DiagnosisDrug *parent;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10Diagnosis *poisoningAccidental;
@property (nonatomic, retain) ICD10Diagnosis *poisoningAssault;
@property (nonatomic, retain) ICD10Diagnosis *poisoningIntentional;
@property (nonatomic, retain) ICD10Diagnosis *poisoningUndetermined;
@property (nonatomic, retain) ICD10Diagnosis *underdosing;
@property (nonatomic, retain) ICD10Diagnosis *adverseEffect;
@end

@interface ICD10DiagnosisDrug (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(ICD10DiagnosisDrug *)value;
- (void)removeChildrenObject:(ICD10DiagnosisDrug *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;

@end

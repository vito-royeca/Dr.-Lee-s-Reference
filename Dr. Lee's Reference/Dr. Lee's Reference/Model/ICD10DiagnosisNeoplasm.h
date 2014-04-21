//
//  ICD10DiagnosisNeoplasm.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Diagnosis, ICD10DiagnosisNeoplasm;

@interface ICD10DiagnosisNeoplasm : NSManagedObject

@property (nonatomic, retain) NSString * neoplasm;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) ICD10Diagnosis *malignantPrimary;
@property (nonatomic, retain) ICD10Diagnosis *malignantSecondary;
@property (nonatomic, retain) ICD10Diagnosis *caInSitu;
@property (nonatomic, retain) ICD10Diagnosis *benign;
@property (nonatomic, retain) ICD10Diagnosis *uncertainBehavior;
@property (nonatomic, retain) ICD10Diagnosis *unspecifiedBehavior;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) ICD10DiagnosisNeoplasm *parent;
@end

@interface ICD10DiagnosisNeoplasm (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(ICD10DiagnosisNeoplasm *)value;
- (void)removeChildrenObject:(ICD10DiagnosisNeoplasm *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end

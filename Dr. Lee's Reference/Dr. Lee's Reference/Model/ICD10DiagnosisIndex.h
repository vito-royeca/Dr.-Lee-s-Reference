//
//  ICD10DiagnosisIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Diagnosis, ICD10DiagnosisIndex;

@interface ICD10DiagnosisIndex : NSManagedObject

@property (nonatomic, retain) NSString * see;
@property (nonatomic, retain) NSString * seeAlso;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) ICD10DiagnosisIndex *parent;
@property (nonatomic, retain) ICD10Diagnosis *code;
@end

@interface ICD10DiagnosisIndex (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(ICD10DiagnosisIndex *)value;
- (void)removeChildrenObject:(ICD10DiagnosisIndex *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end

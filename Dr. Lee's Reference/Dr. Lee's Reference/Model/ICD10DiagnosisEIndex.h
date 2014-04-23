//
//  ICD10DiagnosisEIndex.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Diagnosis, ICD10DiagnosisEIndex;

@interface ICD10DiagnosisEIndex : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * titleInitial;
@property (nonatomic, retain) NSString * seeAlso;
@property (nonatomic, retain) NSString * see;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSOrderedSet *children;
@property (nonatomic, retain) ICD10DiagnosisEIndex *parent;
@property (nonatomic, retain) NSString *code;
@end

@interface ICD10DiagnosisEIndex (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(ICD10DiagnosisEIndex *)value;
- (void)removeChildrenObject:(ICD10DiagnosisEIndex *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;

@end

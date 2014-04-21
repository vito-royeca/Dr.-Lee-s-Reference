//
//  ICD10ProcedureDefinition.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICD10Procedure;

@interface ICD10ProcedureDefinition : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * explanation;
@property (nonatomic, retain) NSString * includes;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) ICD10Procedure *section;
@property (nonatomic, retain) ICD10Procedure *character;

@end

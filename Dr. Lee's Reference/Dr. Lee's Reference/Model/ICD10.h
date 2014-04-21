//
//  ICD10.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ICD10 : NSManagedObject

@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * longName;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSString * icd10Type;
@property (nonatomic, retain) NSString * text;

@end

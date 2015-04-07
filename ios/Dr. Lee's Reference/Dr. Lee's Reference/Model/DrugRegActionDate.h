//
//  DrugRegActionDate.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugApplication, DrugDocType_Lookup;

@interface DrugRegActionDate : NSManagedObject

@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * duplicateCounter;
@property (nonatomic, retain) NSString * inDocTypeSeqNo;
@property (nonatomic, retain) DrugApplication *applNo;
@property (nonatomic, retain) DrugDocType_Lookup *docType;

@end

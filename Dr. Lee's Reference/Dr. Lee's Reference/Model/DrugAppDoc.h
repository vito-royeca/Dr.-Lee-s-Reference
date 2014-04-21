//
//  DrugAppDoc.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DrugAppDocType_Lookup, DrugApplication;

@interface DrugAppDoc : NSManagedObject

@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSNumber * appDocID;
@property (nonatomic, retain) NSDate * docDate;
@property (nonatomic, retain) NSString * docTitle;
@property (nonatomic, retain) NSString * docURL;
@property (nonatomic, retain) NSNumber * duplicateCounter;
@property (nonatomic, retain) NSString * seqNo;
@property (nonatomic, retain) DrugApplication *applNo;
@property (nonatomic, retain) DrugAppDocType_Lookup *docType;

@end

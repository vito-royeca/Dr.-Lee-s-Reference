//
//  AppDoc.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDocType_Lookup, Application;

@interface AppDoc : NSManagedObject

@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSNumber * appDocID;
@property (nonatomic, retain) NSDate * docDate;
@property (nonatomic, retain) NSString * docTitle;
@property (nonatomic, retain) NSString * docURL;
@property (nonatomic, retain) NSNumber * duplicateCounter;
@property (nonatomic, retain) NSString * seqNo;
@property (nonatomic, retain) Application *applNo;
@property (nonatomic, retain) AppDocType_Lookup *docType;

@end

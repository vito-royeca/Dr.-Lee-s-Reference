//
//  AppDoc.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AppDocType_Lookup.h"

@class Application;

@interface AppDoc : NSManagedObject

@property (nonatomic, retain) NSNumber * appDocID;
@property (nonatomic, retain) NSString * seqNo;
@property (nonatomic, retain) AppDocType_Lookup * docType;
@property (nonatomic, retain) NSString * docTitle;
@property (nonatomic, retain) NSString * docURL;
@property (nonatomic, retain) NSDate * docDate;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSNumber * duplicateCounter;
@property (nonatomic, retain) Application *applNo;

@end

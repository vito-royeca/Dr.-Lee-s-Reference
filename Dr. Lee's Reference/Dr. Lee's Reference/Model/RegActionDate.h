//
//  RegActionDate.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application, DocType_Lookup;

@interface RegActionDate : NSManagedObject

@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * duplicateCounter;
@property (nonatomic, retain) NSString * inDocTypeSeqNo;
@property (nonatomic, retain) Application *applNo;
@property (nonatomic, retain) DocType_Lookup *docType;

@end

//
//  RegActionDate.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Application;

@interface RegActionDate : NSManagedObject

@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * inDocTypeSeqNo;
@property (nonatomic, retain) NSString * duplicateCounter;
@property (nonatomic, retain) NSDate * actionDate;
@property (nonatomic, retain) NSString * docType;
@property (nonatomic, retain) Application *applNo;

@end

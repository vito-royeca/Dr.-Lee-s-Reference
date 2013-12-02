//
//  AppDocType_Lookup.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDoc;

@interface AppDocType_Lookup : NSManagedObject

@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString *appDocType;

@end

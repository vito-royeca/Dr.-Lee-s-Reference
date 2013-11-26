//
//  ReviewClass_Lookup.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReviewClass_Lookup : NSManagedObject

@property (nonatomic, retain) NSNumber * reviewClassID;
@property (nonatomic, retain) NSString * reviewCode;
@property (nonatomic, retain) NSString * longDescription;
@property (nonatomic, retain) NSString * shortDescription_;

@end

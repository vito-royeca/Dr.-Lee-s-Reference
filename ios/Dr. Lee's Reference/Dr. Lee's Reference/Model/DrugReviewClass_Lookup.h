//
//  DrugReviewClass_Lookup.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DrugReviewClass_Lookup : NSManagedObject

@property (nonatomic, retain) NSString * longDescription;
@property (nonatomic, retain) NSNumber * reviewClassID;
@property (nonatomic, retain) NSString * reviewCode;
@property (nonatomic, retain) NSString * shortDescription_;

@end

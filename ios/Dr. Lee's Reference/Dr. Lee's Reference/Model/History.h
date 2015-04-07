//
//  History.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject

@property (nonatomic, retain) NSString * query;
@property (nonatomic, retain) NSString * tableName;

@end

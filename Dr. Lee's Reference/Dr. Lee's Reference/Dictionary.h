//
//  Dictionary.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * dictionaryId;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * pronunciation;

@end

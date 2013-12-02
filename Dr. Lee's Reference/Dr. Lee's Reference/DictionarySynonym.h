//
//  DictionarySynonym.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/1/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dictionary;

@interface DictionarySynonym : NSManagedObject

@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) Dictionary *dictionaryId;

@end

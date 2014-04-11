//
//  DictionaryDefinition.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/14/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionaryTerm;

@interface DictionaryDefinition : NSManagedObject

@property (nonatomic, retain) NSString *definition;
@property (nonatomic, retain) DictionaryTerm *dictionaryTerm;

@end

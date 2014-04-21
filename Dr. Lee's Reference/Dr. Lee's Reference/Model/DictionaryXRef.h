//
//  DictionaryXRef.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionaryTerm;

@interface DictionaryXRef : NSManagedObject

@property (nonatomic, retain) NSString * xref;
@property (nonatomic, retain) DictionaryTerm *term;

@end

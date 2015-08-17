//
//  DictionaryXRef.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionaryTerm;

@interface DictionaryXRef : NSManagedObject

@property (nonatomic, retain) NSString * xref;
@property (nonatomic, retain) NSString * termId;
@property (nonatomic, retain) DictionaryTerm *term;

@end
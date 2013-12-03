//
//  Dictionary.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionarySynonym;

@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSString * dictionaryId;
@property (nonatomic, retain) NSString * pronunciation;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSSet *dictionarySynonym;
@end

@interface Dictionary (CoreDataGeneratedAccessors)

- (void)addDictionarySynonymObject:(DictionarySynonym *)value;
- (void)removeDictionarySynonymObject:(DictionarySynonym *)value;
- (void)addDictionarySynonym:(NSSet *)values;
- (void)removeDictionarySynonym:(NSSet *)values;

@end

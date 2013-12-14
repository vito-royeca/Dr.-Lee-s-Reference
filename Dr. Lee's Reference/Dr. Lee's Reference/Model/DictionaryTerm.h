//
//  DictionaryTerm.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/14/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionaryDefinition, DictionarySynonym, DictionaryXRef;

@interface DictionaryTerm : NSManagedObject

@property (nonatomic, retain) NSString * dictionaryId;
@property (nonatomic, retain) NSString * pronunciation;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSSet *dictionarySynonym;
@property (nonatomic, retain) NSSet *dictionaryDefinition;
@property (nonatomic, retain) NSSet *dictionaryXRef;
@end

@interface DictionaryTerm (CoreDataGeneratedAccessors)

- (void)addDictionarySynonymObject:(DictionarySynonym *)value;
- (void)removeDictionarySynonymObject:(DictionarySynonym *)value;
- (void)addDictionarySynonym:(NSSet *)values;
- (void)removeDictionarySynonym:(NSSet *)values;

- (void)addDictionaryDefinitionObject:(DictionaryDefinition *)value;
- (void)removeDictionaryDefinitionObject:(DictionaryDefinition *)value;
- (void)addDictionaryDefinition:(NSSet *)values;
- (void)removeDictionaryDefinition:(NSSet *)values;

- (void)addDictionaryXRefObject:(DictionaryXRef *)value;
- (void)removeDictionaryXRefObject:(DictionaryXRef *)value;
- (void)addDictionaryXRef:(NSSet *)values;
- (void)removeDictionaryXRef:(NSSet *)values;

@end

//
//  DictionaryTerm.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionaryDefinition, DictionarySynonym, DictionaryXRef;

@interface DictionaryTerm : NSManagedObject

@property (nonatomic, retain) NSString * termId;
@property (nonatomic, retain) NSString * pronunciation;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSString * termInitial;
@property (nonatomic, retain) NSSet *synonym;
@property (nonatomic, retain) NSSet *xref;
@property (nonatomic, retain) NSSet *definition;
@end

@interface DictionaryTerm (CoreDataGeneratedAccessors)

- (void)addSynonymObject:(DictionarySynonym *)value;
- (void)removeSynonymObject:(DictionarySynonym *)value;
- (void)addSynonym:(NSSet *)values;
- (void)removeSynonym:(NSSet *)values;

- (void)addXrefObject:(DictionaryXRef *)value;
- (void)removeXrefObject:(DictionaryXRef *)value;
- (void)addXref:(NSSet *)values;
- (void)removeXref:(NSSet *)values;

- (void)addDefinitionObject:(DictionaryDefinition *)value;
- (void)removeDefinitionObject:(DictionaryDefinition *)value;
- (void)addDefinition:(NSSet *)values;
- (void)removeDefinition:(NSSet *)values;

@end

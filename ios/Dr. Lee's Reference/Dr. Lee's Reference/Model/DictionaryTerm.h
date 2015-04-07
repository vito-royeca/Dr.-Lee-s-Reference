//
//  DictionaryTerm.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/30/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DictionarySynonym, DictionaryXRef;

@interface DictionaryTerm : NSManagedObject

@property (nonatomic, retain) NSString * pronunciation;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSString * termId;
@property (nonatomic, retain) NSString * termInitial;
@property (nonatomic, retain) NSString * definition;
@property (nonatomic, retain) NSSet *synonym;
@property (nonatomic, retain) NSSet *xref;
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

@end

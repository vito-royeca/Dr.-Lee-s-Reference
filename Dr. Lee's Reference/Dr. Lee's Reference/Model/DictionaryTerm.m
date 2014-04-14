//
//  DictionaryTerm.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/14/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryTerm.h"
#import "DictionaryDefinition.h"
#import "DictionarySynonym.h"
#import "DictionaryXRef.h"
#import "JJJ/JJJUtil.h"

@implementation DictionaryTerm

@dynamic dictionaryId;
@dynamic pronunciation;
@dynamic term;
@dynamic dictionarySynonym;
@dynamic dictionaryDefinition;
@dynamic dictionaryXRef;

- (NSString *) termInitial
{
    if ([JJJUtil isAlphaStart:[self term]])
    {
        return [[self term] substringToIndex:1];
    }
    else
    {
        return @"SYM";
    }
}
@end

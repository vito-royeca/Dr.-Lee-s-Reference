//
//  StedmansScraper.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"

#define TARGET_WEBSITE        @"http://www.medilexicon.com/medicaldictionary.php"
#define DEFINITIONS_SEPARATOR @"&#&"
#define TERMS_CSV_FILE        @"dictionaryTerms.csv"
#define SYNONYMS_CSV_FILE     @"dictionarySynonyms.csv"
#define XREFS_CSV_FILE        @"dictionaryXRefs.csv"
#define CSV_DELIMETER         '|'

//comment to scrape all
#define SCRAPE_LIMIT          10

@interface DictionaryLoader : NSObject<CHCSVParserDelegate>

-(void) scrape;
-(void) csv2CoreData;

@end

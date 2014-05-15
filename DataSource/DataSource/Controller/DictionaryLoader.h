//
//  DictionaryLoader.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"

#define TARGET_WEBSITE        @"http://www.medilexicon.com/medicaldictionary.php"
#define TERMS_CSV_FILE        @"terms.csv"
#define SYNONYMS_CSV_FILE     @"synonyms.csv"
#define XREFS_CSV_FILE        @"xrefs.csv"
#define CSV_DELIMETER         '|'

// comment the line below to scrape all
//#define SCRAPE_LIMIT          10

@interface DictionaryLoader : NSObject<CHCSVParserDelegate>

-(void) scrape;
-(void) csv2CoreData;

@end

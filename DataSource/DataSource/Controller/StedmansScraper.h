//
//  StedmansScraper.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/30/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Database.h"
#import "DictionaryDefinition.h"
#import "DictionarySynonym.h"
#import "DictionaryTerm.h"
#import "DictionaryXRef.h"
#import "TFHpple.h"
#import "Util.h"

#define TARGET_WEBSITE @"http://www.medilexicon.com/medicaldictionary.php"

@interface StedmansScraper : NSObject

-(void) scrape;

@end

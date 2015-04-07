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
#define CSV_DELIMETER         '|'

@interface DictionaryLoader : NSObject<CHCSVParserDelegate>

-(void) scrape;
-(void) csv2CoreData;

@end

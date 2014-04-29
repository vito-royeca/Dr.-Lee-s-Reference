//
//  Database.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 2/3/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJJ/JJJ.h"

#define kFetchBatchSize       100
#define kDatabaseStore        @"database.sqlite"

typedef enum
{
    DictionaryDataSource = 0,
    DrugsDataSource,
    ICD10DataSource
} DataSource;


@interface Database : NSObject

+ (id)sharedInstance;

- (void) setupDb;

- (NSFetchedResultsController*)search:(DataSource)dataSource
                                query:(NSString*)query
                         narrowSearch:(BOOL)narrow;


@end

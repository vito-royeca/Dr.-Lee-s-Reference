//
//  MigrationManager.h
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/29/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//
//  see http://www.objc.io/issue-4/core-data-migration.html
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface MigrationManager : NSObject

- (BOOL)isMigrationNeeded;
- (BOOL)migrate:(NSError *__autoreleasing *)error;

@end

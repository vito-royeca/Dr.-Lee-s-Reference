//
//  Util.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_DELEGATE                    ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define DEFAULTS                        [NSUserDefaults standardUserDefaults]

@interface Util : NSObject

+ (BOOL)string:(NSString *)string containsString:(NSString*)x;
+ (NSString*) arrayToString:(NSArray*)arr;
@end
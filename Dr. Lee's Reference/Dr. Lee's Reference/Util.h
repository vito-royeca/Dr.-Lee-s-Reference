//
//  Util.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define APP_DELEGATE                    ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//#define DEFAULTS                        [NSUserDefaults standardUserDefaults]

#ifdef _WIN64
    #define _OS_WIN64 1
#elif _WIN32
    #define _OS_WIN32 1
#elif __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_IPHONE && TARGET_IPHONE_SIMULATOR
        #define _OS_IPHONE_SIMULATOR 1
    #elif TARGET_OS_IPHONE
        #define _OS_IPHONE 1
    #else
        #define _OS_OSX 1
    #endif
#elif __linux
    #define _OS_LINUX 1
#elif __unix
    #define _OS_UNIX 1
#elif __posix
    #define _OS_POSIX 1
#endif

@interface Util : NSObject

+ (BOOL)string:(NSString *)string containsString:(NSString*)x;
+ (BOOL)isEmptyString:(NSString*)string;
+ (NSString*) arrayToString:(NSArray*)arr;
+ (NSString*) toUTF8:(NSString*)string;
+ (NSString*) toASCII:(NSString*)string;
+ (NSString*) trim:(NSString*)string;
+ (NSString*) superScriptOf:(NSString*)string;
+ (NSString*) subScriptOf:(NSString*)string;

@end
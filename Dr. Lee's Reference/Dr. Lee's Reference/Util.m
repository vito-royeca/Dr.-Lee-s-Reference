//  Util.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/22/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (BOOL)string:(NSString *)string containsString:(NSString*)x
{
    NSRange isRange = [string rangeOfString:x options:NSCaseInsensitiveSearch];
    if(isRange.location == 0)
    {
        return YES;
    }
    else
    {
        NSRange isSpacedRange = [string rangeOfString:x options:NSCaseInsensitiveSearch];
        if(isSpacedRange.location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString*) arrayToString:(NSArray*)arr
{
    NSMutableString *retString = [[NSMutableString alloc] init];

    for (id i in [arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)])
    {
        [retString appendFormat:@"%@%@", retString.length>0 ? @" ":@"", i];
    }
    
    return retString;
}

+ (NSString*) toUTF8:(NSString*)string
{
    if ([string canBeConvertedToEncoding:NSISOLatin1StringEncoding])
    {
        NSString *utf8 = [NSString stringWithCString:[string cStringUsingEncoding:NSISOLatin1StringEncoding]
                                  encoding:NSUTF8StringEncoding];
        
        return utf8 ? utf8 : string;
    }
    else
    {
        return string;
    }
}

+ (NSString*) trim:(NSString*)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
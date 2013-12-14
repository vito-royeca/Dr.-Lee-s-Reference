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

+ (BOOL)isEmptyString:(NSString*)string
{
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0;
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

+ (NSString*) toASCII:(NSString*)string
{
    if ([string canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        NSString *ascii = [NSString stringWithCString:[string cStringUsingEncoding:NSASCIIStringEncoding]
                                             encoding:NSUTF8StringEncoding];
        
        return ascii ? ascii : string;
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

+ (NSString*) superScriptOf:(NSString*)string
{
    NSMutableString *p = [[NSMutableString alloc] init];
    
    for (int i =0; i<string.length; i++)
    {
        unichar chara=[string characterAtIndex:i];
        
        switch (chara)
        {
            case '1':
            {
                [p appendFormat:@"%@", @"\u00B9"];
                break;
            }
            case '2':
            {
                [p appendFormat:@"%@", @"\u00B2"];
                break;
            }
            case '3':
            {
                [p appendFormat:@"%@", @"\u00B3"];
                break;
            }
            case '4':
            {
                [p appendFormat:@"%@", @"\u2074"];
                break;
            }
            case '5':
            {
                [p appendFormat:@"%@", @"\u2075"];
                break;
            }
            case '6':
            {
                [p appendFormat:@"%@", @"\u2076"];
                break;
            }
            case '7':
            {
                [p appendFormat:@"%@", @"\u2077"];
                break;
            }
            case '8':
            {
                [p appendFormat:@"%@", @"\u2078"];
                break;
            }
            case '9':
            {
                [p appendFormat:@"%@", @"\u2079"];
                break;
            }
            case '0':
            {
                [p appendFormat:@"%@", @"\u2070"];
                break;
            }
            case '+':
            {
                [p appendFormat:@"%@", @"\u207A"];
                break;
            }
            case '-':
            {
                [p appendFormat:@"%@", @"\u207B"];
                break;
            }
            case '=':
            {
                [p appendFormat:@"%@", @"\u207C"];
                break;
            }
            case '(':
            {
                [p appendFormat:@"%@", @"\u207D"];
                break;
            }
            case ')':
            {
                [p appendFormat:@"%@", @"\u207E"];
                break;
            }
            case 'n':
            {
                [p appendFormat:@"%@", @"\u207F"];
                break;
            }
            default:
            {
                [p appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
                break;
            }
        }
    }
    
    return p;
}

+ (NSString*) subScriptOf:(NSString*)string
{
    NSMutableString *p = [[NSMutableString alloc] init];
    
    for (int i =0; i<string.length; i++)
    {
        unichar chara=[string characterAtIndex:i];
        
        switch (chara)
        {
            case '0':
            {
                [p appendFormat:@"%@", @"\u2080"];
                break;
            }
            case '1':
            {
                [p appendFormat:@"%@", @"\u2081"];
                break;
            }
            case '2':
            {
                [p appendFormat:@"%@", @"\u2082"];
                break;
            }
            case '3':
            {
                [p appendFormat:@"%@", @"\u2083"];
                break;
            }
            case '4':
            {
                [p appendFormat:@"%@", @"\u2084"];
                break;
            }
            case '5':
            {
                [p appendFormat:@"%@", @"\u2085"];
                break;
            }
            case '6':
            {
                [p appendFormat:@"%@", @"\u2086"];
                break;
            }
            case '7':
            {
                [p appendFormat:@"%@", @"\u2087"];
                break;
            }
            case '8':
            {
                [p appendFormat:@"%@", @"\u2088"];
                break;
            }
            case '9':
            {
                [p appendFormat:@"%@", @"\u2089"];
                break;
            }
            case '+':
            {
                [p appendFormat:@"%@", @"\u208A"];
                break;
            }
            case '-':
            {
                [p appendFormat:@"%@", @"\u208B"];
                break;
            }
            case '=':
            {
                [p appendFormat:@"%@", @"\u208C"];
                break;
            }
            case '(':
            {
                [p appendFormat:@"%@", @"\u208D"];
                break;
            }
            case ')':
            {
                [p appendFormat:@"%@", @"\u208E"];
                break;
            }
            case 'a':
            {
                [p appendFormat:@"%@", @"\u2090"];
                break;
            }
            case 'e':
            {
                [p appendFormat:@"%@", @"\u2091"];
                break;
            }
            case 'o':
            {
                [p appendFormat:@"%@", @"\u2092"];
                break;
            }
            case 'x':
            {
                [p appendFormat:@"%@", @"\u2093"];
                break;
            }
            case 'h':
            {
                [p appendFormat:@"%@", @"\u2095"];
                break;
            }
            case 'k':
            {
                [p appendFormat:@"%@", @"\u2096"];
                break;
            }
            case 'l':
            {
                [p appendFormat:@"%@", @"\u2097"];
                break;
            }
            case 'm':
            {
                [p appendFormat:@"%@", @"\u2098"];
                break;
            }
            case 'n':
            {
                [p appendFormat:@"%@", @"\u2099"];
                break;
            }
            case 'p':
            {
                [p appendFormat:@"%@", @"\u209A"];
                break;
            }
            case 's':
            {
                [p appendFormat:@"%@", @"\u209B"];
                break;
            }
            case 't':
            {
                [p appendFormat:@"%@", @"\u209C"];
                break;
            }
            default:
            {
                [p appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
                break;
            }
        }
    }
    
    return p;
}


//+ (NSString*) addSuperScriptToString:(NSString*)string
//{
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
//
//    [att beginEditing];
//    [att addAttribute:(NSString*)NSSuperscriptAttributeName
//                value:[NSNumber numberWithInt:1]
//                range:NSMakeRange(0, string.length-1)];
//    [att endEditing];
//    
//    return [att string];
//}
//
//+ (NSString*) addSubScriptToString:(NSString*)string
//{
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
//        [att beginEditing];
//        [att addAttribute:(NSString*)NSSuperscriptAttributeName
//                    value:[NSNumber numberWithInt:-1]
//                    range:NSMakeRange(0, string.length-1)];
//        [att endEditing];
//
//    return [att string];
//}


@end
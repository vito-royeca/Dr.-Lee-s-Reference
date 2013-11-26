//
//  Application.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Application.h"
#import "ChemicalType_Lookup.h"


@implementation Application

@dynamic applNo;
@dynamic applType;
@dynamic sponsorApplicant;
@dynamic mostRecentLabelAvailableFlag;
@dynamic currentPatentFlag;
@dynamic actionType;
@dynamic therapeuticPotential;
@dynamic orphanCode;
@dynamic chemicalType;

-(NSString*) applTypeString
{
    if ([self.applType isEqualToString:@"A"])
    {
        return @"ANDA";
    }
    else if ([self.applType isEqualToString:@"N"])
    {
        return @"NDA";
    }
    else if ([self.applType isEqualToString:@"B"])
    {
        return @"BLA";
    }
    
    return nil;
}
@end

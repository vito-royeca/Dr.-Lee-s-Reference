//
//  Application.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Application.h"
#import "AppDoc.h"
#import "ChemicalType_Lookup.h"
#import "Product.h"
#import "Product_TECode.h"
#import "RegActionDate.h"


@implementation Application

@dynamic actionType;
@dynamic applNo;
@dynamic applType;
@dynamic currentPatentFlag;
@dynamic mostRecentLabelAvailableFlag;
@dynamic orphanCode;
@dynamic sponsorApplicant;
@dynamic therapeuticPotential;
@dynamic appDocId;
@dynamic chemicalType;
@dynamic product;
@dynamic product_teCode;
@dynamic regActionDate;

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

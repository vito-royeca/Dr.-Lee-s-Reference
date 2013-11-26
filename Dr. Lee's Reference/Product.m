//
//  Product.m
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Product.h"
#import "Application.h"


@implementation Product

@dynamic productNo;
@dynamic form;
@dynamic dosage;
@dynamic productMktStatus;
@dynamic teCode;
@dynamic referenceDrug;
@dynamic drugName;
@dynamic activeIngred;
@dynamic applNo;

-(NSString*) productMktStatusString
{
    switch ([self.productMktStatus intValue])
    {
        case 1:
        {
            return @"Prescription";
        }
        case 2:
        {
            return @"OTC";
        }
        case 3:
        {
            return @"Discontinued";
        }
        case 4:
        {
            return @"Tentative Approval";
        }
        default:
        {
            return nil;
        }
    }
}

-(NSString*) referenceDrugString
{
    switch ([self.referenceDrug intValue])
    {
        case 0:
        {
            return @"Not RLD";
        }
        case 1:
        {
            return @"RLD";
        }
        case 2:
        {
            return @"TBD";
        }
        default:
        {
            return nil;
        }
    }
}

@end

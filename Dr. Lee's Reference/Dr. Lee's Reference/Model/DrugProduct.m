//
//  DrugProduct.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 4/21/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DrugProduct.h"
#import "DrugApplication.h"
#import "DrugProduct_TECode.h"


@implementation DrugProduct

@dynamic activeIngred;
@dynamic dosage;
@dynamic drugName;
@dynamic form;
@dynamic productMktStatus;
@dynamic productNo;
@dynamic referenceDrug;
@dynamic teCode;
@dynamic applNo;
@dynamic product_teCode;

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
            return @"No";
        }
        case 1:
        {
            return @"Yes";
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

//
//  Product.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 12/4/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "Product.h"
#import "Application.h"
#import "Product_TECode.h"


@implementation Product

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

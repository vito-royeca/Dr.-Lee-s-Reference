//
//  DrugsLoader.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJJ/JJJ.h"
#import "DrugAppDoc.h"
#import "DrugAppDocType_Lookup.h"
#import "DrugApplication.h"
#import "DrugChemicalType_Lookup.h"
#import "DrugDocType_Lookup.h"
#import "FileDownloader.h"
#import "DrugProduct.h"
#import "DrugProduct_TECode.h"
#import "DrugRegActionDate.h"
#import "DrugReviewClass_Lookup.h"

@interface DrugsLoader : NSObject

-(void) loadDrugs;

@end

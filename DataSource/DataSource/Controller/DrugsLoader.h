//
//  DrugsLoader.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JJJ/JJJ.h"
#import "AppDoc.h"
#import "AppDocType_Lookup.h"
#import "Application.h"
#import "ChemicalType_Lookup.h"
#import "DocType_Lookup.h"
#import "FileDownloader.h"
#import "Product.h"
#import "Product_TECode.h"
#import "RegActionDate.h"
#import "ReviewClass_Lookup.h"

@interface DrugsLoader : NSObject

-(void) loadDrugs;

@end

//
//  DrugsLoader.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/27/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Database.h"
#import "FileDownloader.h"

@interface DrugsLoader : NSObject

-(void) loadDrugs;
-(void) loadChemicalType_Lookup;
-(void) loadReviewClass_Lookup;
-(void) loadApplication;
-(void) loadProduct;
-(void) loadProductTECode;
-(void) loadAppDocType_Lookup;
-(void) loadAppDoc;
-(void) loadDocType_Lookup;
-(void) loadRegActionDate;
-(void) downloadDocuments;

@end

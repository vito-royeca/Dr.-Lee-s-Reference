//
//  Application.h
//  Mobile Drugs@FDA
//
//  Created by Jovito Royeca on 11/19/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//#define appl_type(x) (if (x) isEqualToString:@"A" (@"ANDA") \
//                 else if (x) isEqualToString:@"N" (@"NDA") \
//                 else if (x) isEqualToString:@"B" (@"BLA"))

@class ChemicalType_Lookup;

@interface Application : NSManagedObject

@property (nonatomic, retain) NSString * applNo;
@property (nonatomic, retain) NSString * applType;
@property (nonatomic, retain) NSString * sponsorApplicant;
@property (nonatomic) BOOL mostRecentLabelAvailableFlag;
@property (nonatomic) BOOL currentPatentFlag;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSString * therapeuticPotential;
@property (nonatomic, retain) NSString * orphanCode;
@property (nonatomic, retain) ChemicalType_Lookup *chemicalType;

-(NSString*) applTypeString;

@end

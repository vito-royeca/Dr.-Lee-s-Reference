//
//  DiagnosesLoader.h
//  DataSource
//
//  Created by Jovito Royeca on 4/22/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTES_SEPARATOR @"&#&"
#define ICD10_VERSION   @"2014"

@interface DiagnosesLoader : NSObject

- (void) loadDiagnoses;

@end

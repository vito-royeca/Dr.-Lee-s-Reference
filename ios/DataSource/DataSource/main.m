//
//  main.m
//  DataSource
//
//  Created by Jovito Royeca on 12/11/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DictionaryLoader.h"
#import "DrugsLoader.h"
#import "DiagnosesLoader.h"
#import "ProceduresLoader.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
//        DrugsLoader *drugsLoader = [[DrugsLoader alloc] init];
//        [drugsLoader loadDrugs];
        
//        DictionaryLoader *dictionaryLoader = [[DictionaryLoader alloc] init];
//        [dictionaryLoader scrape];
//        [dictionaryLoader csv2CoreData];
        
//        DiagnosesLoader *diagnosisLoader = [[DiagnosesLoader alloc] init];
//        [diagnosisLoader loadDiagnoses];
        
        ProceduresLoader *proceduresLoader = [[ProceduresLoader alloc] init];
        [proceduresLoader loadProcedures];
    }

    return 0;
}


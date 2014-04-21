//
//  main.m
//  DataSource
//
//  Created by Jovito Royeca on 12/11/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DiagnosesLoader.h"
#import "DrugsLoader.h"
#import "StedmansScraper.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
//        DrugsLoader *loader = [[DrugsLoader alloc] init];
//        [loader loadDrugs];
        
//        StedmansScraper *sc = [[StedmansScraper alloc] init];
//        [sc scrape];
        
        DiagnosesLoader *loader = [[DiagnosesLoader alloc] init];
        [loader loadDiagnoses];
    }

    return 0;
}


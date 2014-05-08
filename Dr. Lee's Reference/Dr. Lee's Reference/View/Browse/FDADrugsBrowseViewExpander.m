//
//  FDADrugsBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "FDADrugsBrowseViewExpander.h"
#import "JJJ/JJJ.h"
#import "RADataObject.h"

@implementation FDADrugsBrowseViewExpander

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    return tree;
}

-(NSArray*) treeStructure:(int) depthLevel withObject:(RADataObject*) object
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    switch (depthLevel)
    {
        case 0:
        {
            break;
        }
    }
    
    return tree;
}

-(NSString*) treeInfo:(int) depthLevel withObject:(RADataObject*) object
{
    return @"FDA Drugs";
}

@end

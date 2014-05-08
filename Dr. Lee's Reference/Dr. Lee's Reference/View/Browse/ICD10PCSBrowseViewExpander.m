//
//  ICD10PCSBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10PCSBrowseViewExpander.h"
#import "RADataObject.h"

@implementation ICD10PCSBrowseViewExpander

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];

    [tree addObjectsFromArray:@[ [[RADataObject alloc] initWithName:@"Tabular" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Index" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Definitions" parent:nil children:nil object:nil]]];
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
    return @"ICD10 PCS";
}
@end

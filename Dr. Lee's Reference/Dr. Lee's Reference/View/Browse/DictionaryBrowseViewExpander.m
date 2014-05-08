//
//  DictionaryBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "DictionaryBrowseViewExpander.h"
#import "JJJ/JJJ.h"
#import "RADataObject.h"

@implementation DictionaryBrowseViewExpander

-(NSArray*) treeStructure:(int) depthLevel
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    switch (depthLevel)
    {
        case 0:
        {
            for (NSString *alpha in [JJJUtil alphabetWithWildcard])
            {
                [tree addObject:[RADataObject dataObjectWithName:alpha children:nil]];
            }
            break;
        }
    }
    
    return tree;
}


@end

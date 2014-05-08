//
//  ICD10CMBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMBrowseViewExpander.h"
#import "ICD10Diagnosis.h"
#import "RADataObject.h"

@implementation ICD10CMBrowseViewExpander

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];

    [tree addObjectsFromArray:@[ [[RADataObject alloc] initWithName:@"Tabular" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Neoplasm" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Drugs" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Index" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Extended Index" parent:nil children:nil object:nil]]];
    return tree;
}

-(NSArray*) treeStructure:(int) depthLevel withObject:(RADataObject*) object
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    switch (depthLevel)
    {
        case 0:
        {
            if ([object.name isEqualToString:@"Tabular"])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
                
                for (ICD10Diagnosis *diag in [ICD10Diagnosis MR_findAllSortedBy:@"first" ascending:YES withPredicate:predicate])
                {
                    NSMutableString *buffer = [[NSMutableString alloc] init];
                    [buffer appendFormat:@"%@", diag.first];
                    if (diag.last)
                    {
                        [buffer appendFormat:@"-%@", diag.last];
                    }
                    RADataObject *data = [[RADataObject alloc] initWithName:buffer parent:object children:nil object:diag];
                    [tree addObject:data];
                }
            }
        }
        case 1:
        {
            if ([object.parent.name isEqualToString:@"Tabular"])
            {
                ICD10Diagnosis *parent = object.object;
                
                for (ICD10Diagnosis *diag in parent.children)
                {
                    NSMutableString *buffer = [[NSMutableString alloc] init];
                    [buffer appendFormat:@"%@", diag.first];
                    if (diag.last)
                    {
                        [buffer appendFormat:@"-%@", diag.last];
                    }
                    RADataObject *data = [[RADataObject alloc] initWithName:buffer parent:object children:nil object:diag];
                    [tree addObject:data];
                }
            }
        }
    }
    
    return tree;
}

-(NSString*) treeInfo:(int) depthLevel withObject:(RADataObject*) object
{
    return @"ICD10 CM";
}

- (UITableViewCell *)cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    RADataObject *data = (RADataObject *)item;
    
    cell.textLabel.text = data.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (treeNodeInfo.treeDepthLevel)
    {
        case 0:
        {
            cell.detailTextLabel.textColor = [UIColor blackColor];
            break;
        }
        case 1:
        case 2:
        {
            ICD10Diagnosis *diag = (ICD10Diagnosis*) data.object;
            NSRange range = [diag.desc rangeOfString:@"(" options:NSBackwardsSearch];
            cell.detailTextLabel.text = [diag.desc substringToIndex:range.location];
            break;
        }
        default:
        {
            
        }
    }
    
    return cell;
}
@end

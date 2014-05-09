//
//  ICD10CMBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMBrowseViewExpander.h"
#import "ICD10CMDetailViewController.h"
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

-(NSArray*) treeStructureForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    RADataObject *object = item;
    
    switch (treeNodeInfo.treeDepthLevel)
    {
        case 0:
        {
            if ([object.name isEqualToString:@"Tabular"])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
                
                for (ICD10Diagnosis *diag in [ICD10Diagnosis MR_findAllSortedBy:@"first" ascending:YES withPredicate:predicate])
                {
                    NSMutableString *buffer = [[NSMutableString alloc] init];
                    if (diag.first)
                    {
                        [buffer appendFormat:@"%@", diag.first];
                        if (diag.last)
                        {
                            [buffer appendFormat:@"-%@", diag.last];
                        }
                    }
                    else
                    {
                        [buffer appendFormat:@"%@", diag.name];
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
                    if (diag.first)
                    {
                        [buffer appendFormat:@"%@", diag.first];
                        if (diag.last)
                        {
                            [buffer appendFormat:@"-%@", diag.last];
                        }
                    }
                    else
                    {
                        [buffer appendFormat:@"%@", diag.name];
                    }
                    RADataObject *data = [[RADataObject alloc] initWithName:buffer parent:object children:nil object:diag];
                    [tree addObject:data];
                }
            }
        }
        case 2:
        {
            if ([object.parent.parent.name isEqualToString:@"Tabular"])
            {
                ICD10Diagnosis *parent = object.object;
                
                for (ICD10Diagnosis *diag in parent.children)
                {
                    NSMutableString *buffer = [[NSMutableString alloc] init];
                    if (diag.first)
                    {
                        [buffer appendFormat:@"%@", diag.first];
                        if (diag.last)
                        {
                            [buffer appendFormat:@"-%@", diag.last];
                        }
                    }
                    else
                    {
                        [buffer appendFormat:@"%@", diag.name];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = data.name;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    ICD10Diagnosis *diag = (ICD10Diagnosis*) data.object;
    if (diag)
    {
        cell.detailTextLabel.text = diag.desc;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
//    switch (treeNodeInfo.treeDepthLevel)
//    {
//        case 0:
//        {
//            cell.detailTextLabel.textColor = [UIColor blackColor];
//            break;
//        }
//        case 1:
//        case 2:
//        case 3:
//        {
//            ICD10Diagnosis *diag = (ICD10Diagnosis*) data.object;
//            
//            cell.detailTextLabel.text = diag.desc;
//            break;
//        }
//        default:
//        {
//            
//        }
//    }
    
    return cell;
}

-(UIViewController*) detailViewForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel > 0)
    {
        RADataObject *data = item;
        return [[ICD10CMDetailViewController alloc] initWithDiagnosis:data.object];
    }
    return nil;
}

@end

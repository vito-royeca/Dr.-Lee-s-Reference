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
#import "ICD10DiagnosisNeoplasm.h"
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
    NSArray *children;
    NSString *name;
    
    
    if (treeNodeInfo.treeDepthLevel == 0)
    {
        name = object.name;
    }
    else
    {
        while (object)
        {
            name = object.name;
            object = object.parent;
        }
        object = item;
    }
    
    if ([name isEqualToString:@"Tabular"])
    {
        if (treeNodeInfo.treeDepthLevel == 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
            children = [ICD10Diagnosis MR_findAllSortedBy:@"first" ascending:YES withPredicate:predicate];
        }
        else
        {
            ICD10Diagnosis *parent = object.object;
            children = [parent.children array];
        }
        
        for (ICD10Diagnosis *diag in children)
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
    
    else if ([name isEqualToString:@"Neoplasm"])
    {
        if (treeNodeInfo.treeDepthLevel == 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
            children = [ICD10DiagnosisNeoplasm MR_findAllSortedBy:@"title" ascending:YES withPredicate:predicate];
        }
        else
        {
            ICD10DiagnosisNeoplasm *parent = object.object;
            children = [parent.children array];
        }
        
        for (ICD10DiagnosisNeoplasm *neo in children)
        {
            RADataObject *data = [[RADataObject alloc] initWithName:neo.title parent:object children:nil object:neo];
            [tree addObject:data];
        }
    }
    
    else if ([name isEqualToString:@"Drugs"])
    {
        
    }
    
    else if ([name isEqualToString:@"Index"])
    {
        
    }
    
    else if ([name isEqualToString:@"Extended Index"])
    {
        
    }
    
    return tree;
}

- (UITableViewCell *)cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    RADataObject *data = (RADataObject *)item;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = data.name;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.imageView.image = nil;
    
    if ([data.object isKindOfClass:[ICD10Diagnosis class]])
    {
        ICD10Diagnosis *diag = data.object;

        cell.detailTextLabel.text = diag.desc;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        if (diag.children.count > 0)
        {
            if (treeNodeInfo.expanded)
            {
                cell.imageView.image = [UIImage imageNamed:@"down4.png"];
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"forward.png"];
            }
        }
    }
    else if ([data.object isKindOfClass:[ICD10DiagnosisNeoplasm class]])
    {
        ICD10DiagnosisNeoplasm *neo = data.object;
        
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        if (neo.children.count > 0)
        {
            if (treeNodeInfo.expanded)
            {
                cell.imageView.image = [UIImage imageNamed:@"down4.png"];
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"forward.png"];
            }
        }
    }
    
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

//
//  ICD10CMBrowseViewExpander.m
//  Dr. Lee's Reference
//
//  Created by Jovit Royeca on 5/8/14.
//  Copyright (c) 2014 Jovito Royeca. All rights reserved.
//

#import "ICD10CMBrowseViewExpander.h"
#import "JJJ/JJJ.h"
#import "ICD10CMDetailViewController.h"
#import "ICD10Diagnosis.h"
#import "ICD10DiagnosisDrug.h"
#import "ICD10DiagnosisEIndex.h"
#import "ICD10DiagnosisIndex.h"
#import "ICD10DiagnosisNeoplasm.h"
#import "RADataObject.h"

@implementation ICD10CMBrowseViewExpander

-(NSArray*) initialTreeStructure
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];

    [tree addObjectsFromArray:@[ [[RADataObject alloc] initWithName:@"Tabular" parent:nil children:nil object:nil],
                                 [[RADataObject alloc] initWithName:@"Neoplasms" parent:nil children:nil object:nil],
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
    
    else if ([name isEqualToString:@"Neoplasms"])
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
        if (treeNodeInfo.treeDepthLevel == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
            
            for (NSString *alpha in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:alpha parent:object children:nil object:alpha];
                [tree addObject:data];
            }
        }
        else
        {
            if (treeNodeInfo.treeDepthLevel == 1)
            {
                NSString *alpha = object.object;
                
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"substance", alpha];
                
                children = [ICD10DiagnosisDrug MR_findAllSortedBy:@"substance"
                                                        ascending:YES
                                                    withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
            else
            {
                ICD10DiagnosisDrug *parent = object.object;
                children = [parent.children array];
            }
            
            for (ICD10DiagnosisDrug *drug in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:drug.substance parent:object children:nil object:drug];
                [tree addObject:data];
            }
        }
    }
    
    else if ([name isEqualToString:@"Index"])
    {
        if (treeNodeInfo.treeDepthLevel == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
            
            for (NSString *alpha in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:alpha parent:object children:nil object:alpha];
                [tree addObject:data];
            }
        }
        else
        {
            if (treeNodeInfo.treeDepthLevel == 1)
            {
                NSString *alpha = object.object;
                
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", alpha];
                
                children = [ICD10DiagnosisIndex MR_findAllSortedBy:@"title"
                                                        ascending:YES
                                                    withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
            else
            {
                ICD10DiagnosisIndex *parent = object.object;
                children = [parent.children array];
            }
            
            for (ICD10DiagnosisIndex *index in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:index.title parent:object children:nil object:index];
                [tree addObject:data];
            }
        }
    }
    
    else if ([name isEqualToString:@"Extended Index"])
    {
        if (treeNodeInfo.treeDepthLevel == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
            
            for (NSString *alpha in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:alpha parent:object children:nil object:alpha];
                [tree addObject:data];
            }
        }
        else
        {
            if (treeNodeInfo.treeDepthLevel == 1)
            {
                NSString *alpha = object.object;
                
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", alpha];
                
                children = [ICD10DiagnosisEIndex MR_findAllSortedBy:@"title"
                                                         ascending:YES
                                                     withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
            else
            {
                ICD10DiagnosisEIndex *parent = object.object;
                children = [parent.children array];
            }
            
            for (ICD10DiagnosisEIndex *index in children)
            {
                RADataObject *data = [[RADataObject alloc] initWithName:index.title parent:object children:nil object:index];
                [tree addObject:data];
            }
        }
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
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    if ([data.object isKindOfClass:[ICD10Diagnosis class]])
    {
        ICD10Diagnosis *diag = data.object;

        cell.detailTextLabel.text = diag.desc;
    }
    else if ([data.object isKindOfClass:[ICD10DiagnosisNeoplasm class]])
    {
        ICD10DiagnosisNeoplasm *neo = data.object;
    }
    else if ([data.object isKindOfClass:[ICD10DiagnosisDrug class]])
    {
        ICD10DiagnosisDrug *drug = data.object;
    }
    else if ([data.object isKindOfClass:[ICD10DiagnosisIndex class]])
    {
        ICD10DiagnosisIndex *index = data.object;
    }
    else if ([data.object isKindOfClass:[ICD10DiagnosisEIndex class]])
    {
        ICD10DiagnosisEIndex *index = data.object;
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

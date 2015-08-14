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

    [tree addObjectsFromArray:@[ [[RADataObject alloc] initWithName:@"Tabular"
                                                            details:@"Tabular List of Diseases and Injuries"
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Neoplasms"
                                                            details:@"Table of Neoplasms"
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Drugs"
                                                            details:@"Table of Drugs and Chemicals"
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Index"
                                                            details:@"Index To Diseases and Injuries"
                                                             parent:nil
                                                           children:nil
                                                             object:nil],
                                 [[RADataObject alloc] initWithName:@"Extended Index"
                                                            details:@"External Cause of Injuries Index"
                                                             parent:nil
                                                           children:nil
                                                             object:nil]]];
    return tree;
}

-(NSString *) parentName:(RADataObject*) item
{
    RADataObject *data = item;
    
    if (data.parent)
    {
        do
        {
            data = data.parent;
        }
        while (data.parent);
    }
    return data.name;
}

- (NSArray*) constructTreeFromParent:(id)parent andChildren:(NSArray*) children
{
    NSMutableArray *tree = [[NSMutableArray alloc] init];
    
    for (id child in children)
    {
        if ([child isKindOfClass:[ICD10Diagnosis class]])
        {
            ICD10Diagnosis *diag = child;
            
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
            RADataObject *data = [[RADataObject alloc] initWithName:buffer
                                                            details:diag.desc
                                                             parent:parent
                                                           children:nil
                                                             object:diag];
            [tree addObject:data];
            
        }
        else if ([child isKindOfClass:[ICD10DiagnosisNeoplasm class]])
        {
            ICD10DiagnosisNeoplasm *neo = child;
            
            RADataObject *data = [[RADataObject alloc] initWithName:neo.title
                                                            details:nil
                                                             parent:parent
                                                           children:nil
                                                             object:neo];
            [tree addObject:data];
        }
        else if ([child isKindOfClass:[ICD10DiagnosisDrug class]])
        {
            ICD10DiagnosisDrug *drug = child;
            
            RADataObject *data = [[RADataObject alloc] initWithName:drug.substance
                                                            details:nil
                                                             parent:parent
                                                           children:nil
                                                             object:drug];
            [tree addObject:data];
        }
        else if ([child isKindOfClass:[ICD10DiagnosisIndex class]])
        {
            ICD10DiagnosisIndex *index = child;
            
            RADataObject *data = [[RADataObject alloc] initWithName:index.title
                                                            details:nil
                                                             parent:parent
                                                           children:nil
                                                             object:index];
            [tree addObject:data];
        }
        else if ([child isKindOfClass:[ICD10DiagnosisEIndex class]])
        {
            ICD10DiagnosisEIndex *index = child;
            
            RADataObject *data = [[RADataObject alloc] initWithName:index.title
                                                            details:nil
                                                             parent:parent
                                                           children:nil
                                                             object:index];
            [tree addObject:data];
        }
        else if ([child isKindOfClass:[NSString class]])
        {
            NSString *alpha = child;
            
            RADataObject *data = [[RADataObject alloc] initWithName:alpha
                                                            details:nil
                                                             parent:parent
                                                           children:nil
                                                             object:alpha];
            [tree addObject:data];
        }
    }
    
    return tree;
}

-(NSArray*) treeStructureForItem:(id)item
{
    RADataObject *object = item;
    NSString *name = object.name;
    NSArray *children;
    
    if ([name isEqualToString:@"Tabular"])
    {
        if (!object.children || object.children.count == 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
//            children = [ICD10Diagnosis MR_findAllSortedBy:@"first" ascending:YES withPredicate:predicate];
        }
    }
    else if ([name isEqualToString:@"Neoplasms"])
    {
        if (!object.children || object.children.count == 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = nil"];
//            children = [ICD10DiagnosisNeoplasm MR_findAllSortedBy:@"title" ascending:YES withPredicate:predicate];
        }
    }
    else if ([name isEqualToString:@"Drugs"])
    {
        if (!object.children || object.children.count == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
        }
    }
    else if ([name isEqualToString:@"Index"])
    {
        if (!object.children || object.children.count == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
        }
    }
    else if ([name isEqualToString:@"Extended Index"])
    {
        if (!object.children || object.children.count == 0)
        {
            children = [JJJUtil alphabetWithWildcard];
        }
    }
    else
    {
        if (!object.children || object.children.count == 0)
        {
            
        if ([object.object isKindOfClass:[ICD10Diagnosis class]])
        {
            ICD10Diagnosis *diag = object.object;
            children = [diag.children array];
        }
        else if ([object.object isKindOfClass:[ICD10DiagnosisNeoplasm class]])
        {
            ICD10DiagnosisNeoplasm *neo = object.object;
            children = [neo.children array];
        }
        else if ([object.object isKindOfClass:[ICD10DiagnosisDrug class]])
        {
            ICD10DiagnosisDrug *drug = object.object;
            children = [drug.children array];
        }
        else if ([object.object isKindOfClass:[ICD10DiagnosisIndex class]])
        {
            ICD10DiagnosisIndex *index = object.object;
            children = [index.children array];
        }
        else if ([object.object isKindOfClass:[ICD10DiagnosisEIndex class]])
        {
            ICD10DiagnosisEIndex *index = object.object;
            children = [index.children array];
        }
        else if ([object.object isKindOfClass:[NSString class]])
        {
            NSString *parent = [self parentName:object];
            
            if ([parent isEqualToString:@"Drugs"])
            {
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"substance", name];
                
//                children = [ICD10DiagnosisDrug MR_findAllSortedBy:@"substance"
//                                                        ascending:YES
//                                                    withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
            else if ([parent isEqualToString:@"Index"])
            {
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", name];
                
//                children = [ICD10DiagnosisIndex MR_findAllSortedBy:@"title"
//                                                         ascending:YES
//                                                     withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
            else if ([parent isEqualToString:@"Extended Index"])
            {
                NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"parent = nil"];
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", @"title", name];
                
//                children = [ICD10DiagnosisEIndex MR_findAllSortedBy:@"title"
//                                                          ascending:YES
//                                                      withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]]];
            }
        }
        }
    }
    
    return [self constructTreeFromParent:object andChildren:children];
}

//-(NSString*) infoPathForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
//{
//    if (treeNodeInfo.treeDepthLevel == 0)
//    {
//        RADataObject *object = item;
//        NSString *name = object.name;
//        
//        if ([name isEqualToString:@"Tabular"])
//        {
//            return [[NSBundle mainBundle] pathForResource:@"icd10cmTabular" ofType:@"html"];
//        }
//        else if ([name isEqualToString:@"Neoplasms"])
//        {
//            return [[NSBundle mainBundle] pathForResource:@"icd10cmNeoplasms" ofType:@"html"];
//        }
//    }
//    return nil;
//}

@end

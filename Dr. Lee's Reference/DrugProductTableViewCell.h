//
//  DrugProductTableViewCell.h
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/29/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Product.h"

@interface DrugProductTableViewCell : UITableViewCell

@property(strong,nonatomic) UILabel *lblStrength;
@property(strong,nonatomic) UILabel *lblDosage;
@property(strong,nonatomic) UILabel *lblMarketingStatus;
@property(strong,nonatomic) UILabel *lblRLD;
@property(strong,nonatomic) UILabel *lblTECode;

@property(strong,nonatomic) Product *product;

@end

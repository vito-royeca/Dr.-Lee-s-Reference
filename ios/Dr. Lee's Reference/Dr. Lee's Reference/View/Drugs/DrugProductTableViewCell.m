//
//  DrugProductTableViewCell.m
//  Dr. Lee's Reference
//
//  Created by Jovito Royeca on 11/29/13.
//  Copyright (c) 2013 Jovito Royeca. All rights reserved.
//

#import "DrugProductTableViewCell.h"

@implementation DrugProductTableViewCell

@synthesize lblStrength;
@synthesize lblDosage;
@synthesize lblMarketingStatus;
@synthesize lblRLD;
@synthesize lblTECode;
@synthesize drugProduct;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = self.contentView.frame.size.width/16.0*15.0;
        CGFloat edge = (self.contentView.frame.size.width-width)/2;
        CGFloat x = edge;
        CGFloat y = 0;
        CGFloat widthLabel = (width/5)*2;
        CGFloat widthValue = (width/5)*3;
        CGFloat height = 20;
        
        // Initialization code
        UILabel *lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, widthLabel, height)];
        lblLabel.text = @"Strength";
        [self addSubview:lblLabel];
        lblStrength = [[UILabel alloc] initWithFrame:CGRectMake(widthLabel+edge, y, widthValue, height)];
        [self addSubview:lblStrength];
        
        lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, height, widthLabel, height)];
        lblLabel.text = @"Dosage";
        [self addSubview:lblLabel];
        lblDosage = [[UILabel alloc] initWithFrame:CGRectMake(widthLabel+edge, height, widthValue, height)];
        [self addSubview:lblDosage];
        
        lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, height*2, widthLabel, height)];
        lblLabel.text = @"Marketing Status";
        [self addSubview:lblLabel];
        lblMarketingStatus = [[UILabel alloc] initWithFrame:CGRectMake(widthLabel+edge, height*2, widthValue, height)];
        [self addSubview:lblMarketingStatus];
        
        lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, height*3, widthLabel, height)];
        lblLabel.text = @"RLD";
        [self addSubview:lblLabel];
        lblRLD = [[UILabel alloc] initWithFrame:CGRectMake(widthLabel+edge, height*3, widthValue, height)];
        [self addSubview:lblRLD];
        
        lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, height*4, widthLabel, height)];
        lblLabel.text = @"TE Code   ";
        [self addSubview:lblLabel];
        lblTECode = [[UILabel alloc] initWithFrame:CGRectMake(widthLabel+edge, height*4, widthValue, height)];
        [self addSubview:lblTECode];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

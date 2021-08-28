//
//  StatsTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 28/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "StatsTableViewCell.h"

@implementation StatsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.colorView.layer.borderColor = [UIColor colorWithRed:58.0f/255.0f green:95.0f/255.0f blue:103.0f/255.0f alpha:1.0f].CGColor;
    self.colorView.layer.borderWidth = 0.5f;
    
    [self.countLabel setTextColor:[UIColor whiteColor]];
    [self.countLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:13.0f]];
    [self.countLabel setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.4]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

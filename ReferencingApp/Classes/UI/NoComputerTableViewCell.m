//
//  NoComputerTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 23/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "NoComputerTableViewCell.h"

@implementation NoComputerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [_findOutMoreButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

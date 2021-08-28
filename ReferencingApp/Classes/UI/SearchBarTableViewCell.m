//
//  SearchBarTableViewCell.m
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import "SearchBarTableViewCell.h"

@implementation SearchBarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - User Actions

- (IBAction)seachAction:(id)sender
{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(didEndEditingSearchBarCell:strValue:)]) {
            [self.delegate didEndEditingSearchBarCell:self strValue:self.searchField.text];
        }
    }
}

@end

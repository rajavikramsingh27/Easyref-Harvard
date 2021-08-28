//
//  FullWidthTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "FullWidthTableViewCell.h"

@implementation FullWidthTableViewCell 

- (void)awakeFromNib {
    // Initialization code
//    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if ([_delegate respondsToSelector:@selector(editingEndedAtCell:)])
//    {
//        [_delegate editingEndedAtCell:self];
//    }
//}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return FALSE;
}

@end

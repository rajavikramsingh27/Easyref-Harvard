//
//  DoubleTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "DoubleTableViewCell.h"

@implementation DoubleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _firstTextField.delegate = self;
    _secondTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return FALSE;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField == _firstTextField)
    {
        if ([_delegate respondsToSelector:@selector(surnameEndEditingAtCell:)])
            [_delegate surnameEndEditingAtCell:self];

    }
    else
    {
        if ([_delegate respondsToSelector:@selector(initialsEndEditingAtCell:)])
            [_delegate initialsEndEditingAtCell:self];

    }
    
}


- (IBAction)addRemoveButtonPressed:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(addButtonPressedAtCell:)])
    {
        [_delegate addButtonPressedAtCell:self];
    }
}
@end

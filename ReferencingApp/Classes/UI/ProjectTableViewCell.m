//
//  ProjectTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 18/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "ProjectTableViewCell.h"

@implementation ProjectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    [_projectTextField setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
    _projectTextField.delegate = self;
    [_numberLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:12.0f]];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;

    _panGesture.delegate = self;
    
    [_coverView addGestureRecognizer:_panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x = 0;
    self.coverView.frame = newFrame;

    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    if ([_delegate respondsToSelector:@selector(canSlide)])
    {
        if ([_delegate canSlide] == true)
            return YES;
        else
            return NO;
    }
    
    if ([panGestureRecognizer class] == [UIPanGestureRecognizer class]) {
        
        CGPoint velocity = [panGestureRecognizer velocityInView:self.coverView];
        return fabs(velocity.x) > fabs(velocity.y);
        
        return YES;
    }
    return NO;

    
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
   
    
    
    CGPoint translate = [recognizer translationInView:self];
    
    
    
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x += translate.x;
    
    if (newFrame.origin.x < -220)//-165)
        newFrame.origin.x = -220;//-165;
    if (newFrame.origin.x > 0)
        newFrame.origin.x = 0;

    self.coverView.frame = newFrame;
    

    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [recognizer velocityInView:self];
        
//        if (velocity.x < - 150)
//        {
//            newFrame.origin.x = -165;
//        }
//        else if (velocity.x > 150)
//        {
//            newFrame.origin.x = 0;
//        }
//        else if (newFrame.origin.x < -55)
//        {
//            newFrame.origin.x = -165;
//        }
//        else
//        {
//            newFrame.origin.x = 0;
//        }
        
        if (velocity.x < - 150)
        {
            newFrame.origin.x = -220;
        }
        else if (velocity.x > 150)
        {
            newFrame.origin.x = 0;
        }
        else if (newFrame.origin.x < -55)
        {
            newFrame.origin.x = -220;
        }
        else
        {
            newFrame.origin.x = 0;
        }
        
        [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
            self.coverView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btn_settings:(id)sender {
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x = 0;
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setting_ProjectReference" object:self];
    }];
}

- (IBAction)editButtonPressed:(id)sender {
    if ([_projectTextField.text isEqualToString:@"Uncategorized"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"The Uncategorized project can not be edited"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self goToEditMode];
}

-(void)goToEditMode
{
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x = 0;
    
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        [_projectTextField setUserInteractionEnabled:true];
        [_projectTextField becomeFirstResponder];
        
        if ([_delegate respondsToSelector:@selector(editButtonPressedAtCell:)])
        {
            [_delegate editButtonPressedAtCell:self];
        }
        
    }];
}

-(void)shake {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(self.center.x - 5,self.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(self.center.x + 5, self.center.y)]];
    [self.layer addAnimation:shake forKey:@"position"];
}

- (IBAction)deleteButtonPressed:(id)sender
{
    
    if ([_projectTextField.text isEqualToString:@"Uncategorized"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"The Uncategorized project can not be deleted"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x = 0;
    
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(deleteButtonPressedAtCell:)])
        {
            [_delegate deleteButtonPressedAtCell:self];
        }
    }];

    
    
}

- (IBAction)exportButtonPressed:(id)sender
{
    CGRect newFrame = _coverView.frame;
    newFrame.origin.x = 0;
    
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        if ([_delegate respondsToSelector:@selector(exportButtonPressedAtCell:)])
        {
            [_delegate exportButtonPressedAtCell:self];
        }
    }];

}

-(void)endEditing
{
    [self textFieldShouldReturn:_projectTextField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.text.length > 0)
        textField.text = [[[textField.text substringToIndex:1] uppercaseString] stringByAppendingString:[textField.text substringFromIndex:1]];

    return true;
        
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || [textField.text isEqualToString:@"Uncategorized"])
    {
        [self shake];
        return false;
    }
    
    if ([_delegate respondsToSelector:@selector(editingFinishedAtCell:)])
    {
        [_delegate editingFinishedAtCell:self];
    }
    
    [textField setUserInteractionEnabled:false];
    [textField resignFirstResponder];
    return false;
}

@end

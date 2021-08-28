//
//  ReferencesTableViewCell.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "ReferencesTableViewCell.h"

@implementation ReferencesTableViewCell

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
    
    [super awakeFromNib];
    
    canDrag = TRUE;

    [self.deleteButton addTarget:self action:@selector(deleteThis) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.exportButton addTarget:self action:@selector(exportButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)setCanDrag:(BOOL)boolVal
{
    canDrag = boolVal;
}
-(void)deleteThis
{
    [self deleteButtonPressed:nil];
}


- (IBAction)deleteButtonPressed:(id)sender
{
    
    if ([self.projectTextField.text isEqualToString:@"Uncategorized"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"The Uncategorized project can not be deleted"
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CGRect newFrame = self.coverView.frame;
    newFrame.origin.x = 8;
    
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(deleteButtonPressedAtCell:)])
        {
            [self.delegate deleteButtonPressedAtCell:self];
        }
    }];
    
    
    
}





- (void)editButtonPressed:(id)sender
{
    
    CGRect newFrame = self.coverView.frame;
    newFrame.origin.x = 8;
    
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
        self.coverView.frame = newFrame;
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(editButtonPressedAtCell:)])
        {
            [self.delegate editButtonPressedAtCell:self];
        }
        
    }];
}

- (void)prepareForReuse {
    
    CGRect newFrame = self.coverView.frame;
    newFrame.origin.x = 8;
    self.coverView.frame = newFrame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (canDrag == false)
        return;
    
    CGPoint translate = [recognizer translationInView:self];
    
    CGRect newFrame = self.coverView.frame;
    newFrame.origin.x += translate.x;
    
    if (newFrame.origin.x < -216)
        newFrame.origin.x = -216;
    if (newFrame.origin.x > 75)
        newFrame.origin.x = 75;
    
    self.coverView.frame = newFrame;
    
    
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [recognizer velocityInView:self];
        
        
        if (velocity.x < - 150)
        {
            newFrame.origin.x = -216;
        }
        else if (velocity.x > 150)
        {
            newFrame.origin.x = 8;
        }
        else if (newFrame.origin.x < -55)
        {
            newFrame.origin.x = -216;
        }
        else
        {
            newFrame.origin.x = 8;
        }
        
        [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:10.0f options:kNilOptions animations:^{
            self.coverView.frame = newFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}




@end

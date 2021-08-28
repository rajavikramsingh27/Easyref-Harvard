//
//  DoubleTableViewCell.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@class DoubleTableViewCell;

@protocol DoubleCellDelegate <NSObject>

@optional

-(void)addButtonPressedAtCell:(DoubleTableViewCell *)cell;
-(void)surnameEndEditingAtCell:(DoubleTableViewCell *)cell;
-(void)initialsEndEditingAtCell:(DoubleTableViewCell *)cell;


@end


@interface DoubleTableViewCell : UITableViewCell < UITextFieldDelegate >


@property(nonatomic,assign)id<DoubleCellDelegate> delegate;


@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *firstTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *secondTextField;
@property (weak, nonatomic) IBOutlet UIButton *addRemoveButton;

- (IBAction)addRemoveButtonPressed:(id)sender;

@end

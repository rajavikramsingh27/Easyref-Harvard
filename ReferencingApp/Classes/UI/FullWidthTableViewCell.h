//
//  FullWidthTableViewCell.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@class FullWidthTableViewCell;

@protocol FullWidthCellDelegate <NSObject>

-(void)editingEndedAtCell:(FullWidthTableViewCell *)cell;

@end

@interface FullWidthTableViewCell : UITableViewCell < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *textField;
@property(nonatomic,assign)id<FullWidthCellDelegate> delegate;



@end

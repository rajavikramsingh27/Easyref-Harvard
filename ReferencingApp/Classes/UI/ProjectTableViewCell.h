//
//  ProjectTableViewCell.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 18/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class ProjectTableViewCell;

@protocol SlideableCellDelegate <NSObject>

@optional


-(BOOL)canSlide;
-(void)deleteButtonPressedAtCell:(ProjectTableViewCell *)cell;
-(void)editButtonPressedAtCell:(ProjectTableViewCell *)cell;
-(void)editingFinishedAtCell:(ProjectTableViewCell *)cell;
-(void)exportButtonPressedAtCell:(ProjectTableViewCell *)cell;

@end

@interface ProjectTableViewCell : UITableViewCell < UIGestureRecognizerDelegate, UITextFieldDelegate >


@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectTextField;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@property (nonatomic)  UIPanGestureRecognizer *panGesture;


- (IBAction)editButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)exportButtonPressed:(id)sender;

-(void)goToEditMode;
-(void)endEditing;
-(void)shake;

@property(nonatomic,assign)id delegate;

@end

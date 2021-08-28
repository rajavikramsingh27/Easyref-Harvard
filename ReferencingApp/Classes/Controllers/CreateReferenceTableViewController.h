//
//  CreateReferenceTableViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleTableViewCell.h"
#import "Project.h"
#import "Reference.h"
#import "FullWidthTableViewCell.h"
#import "ReferencingApp.h"
#import "LoadingView.h"
#import "ProjectSelectorViewController.h"

#import "SearchBarTableViewCell.h"

@interface CreateReferenceTableViewController : UITableViewController < DoubleCellDelegate, FullWidthCellDelegate, ReferencingAppNetworkDelegate, ProjectSelectorDelegate, UITextFieldDelegate, SearchBarTableViewCellDelegate>
{
    UIView *headerView;
    LoadingView *loadingView;
    NSArray *typeData;
//    NSDictionary *typeDictionary;
    NSMutableDictionary *typeDictionary;
    NSMutableDictionary *refDataDictionary;
    BOOL singleAuthor;
    BOOL hasEditors;
    NSMutableArray *authorArray;
}

@property (strong,nonatomic) Project *currentProject;
@property (strong,nonatomic) Reference *currentReference;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_ChooseYourCitationStyle;

- (IBAction)btn_ChooseYourCitationStyle:(id)sender;

- (IBAction)saveButtonPressed:(id)sender;

@end



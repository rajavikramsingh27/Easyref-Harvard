//
//  CreateReference_ViewController.h
//  Harvard
//
//  Created by appentus technologies pvt. ltd. on 10/14/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN



@interface CreateReference_ViewController : UIViewController< DoubleCellDelegate, FullWidthCellDelegate, ReferencingAppNetworkDelegate, ProjectSelectorDelegate, UITextFieldDelegate, SearchBarTableViewCellDelegate> {
    UIView *headerView;
    LoadingView *loadingView;
    NSArray *typeData;
    NSDictionary *typeDictionary;
    NSMutableDictionary *refDataDictionary;
    BOOL singleAuthor;
    BOOL hasEditors;
    NSMutableArray *authorArray;
}

@property (strong) NSMutableArray *arr_Style_Picker;

@property (strong,nonatomic) Project *currentProject;
@property (strong,nonatomic) Reference *currentReference;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) IBOutlet UITableView *tbl_creat_reference;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txt_ChooseYourCitationStyle;

- (IBAction)btn_ChooseYourCitationStyle:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@property (strong,nonatomic) NSString *str_Selected_Style;

@end



NS_ASSUME_NONNULL_END

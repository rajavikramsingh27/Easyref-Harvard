//
//  ProjecsTableViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 14/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTableViewCell.h"
#import "Project.h"
#import "LoadingView.h"
#import "ReferencingApp.h"
#import <MessageUI/MessageUI.h>


@interface ProjectsTableViewController : UITableViewController < SlideableCellDelegate, ReferencingAppNetworkDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate >
{
  
    UIRefreshControl *refreshControl;
  
    NSArray *projectsArray;
    Project *selectedProject;
    
    NSString *preEditString;
    LoadingView *loadingView;
    
    bool dontCallEditing;
    bool newCell;
    ProjectTableViewCell *editingCell;
    NSIndexPath *deleteIndexPath;
}
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)newProjectButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *headerView;



@property (nonatomic) BOOL secondLevel;
@property (nonatomic) BOOL openProjectCreation;
@property (nonatomic) BOOL showingOnlineProjects;

@property (weak, nonatomic) IBOutlet UILabel *createLabel;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;

@property (weak, nonatomic) IBOutlet UITextField *txt_Styles;
@property (weak, nonatomic) IBOutlet UIView *view_Styles;
@property (weak, nonatomic) IBOutlet UIView *view_White_Styles;
@end

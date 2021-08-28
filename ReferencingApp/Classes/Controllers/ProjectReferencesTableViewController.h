//
//  ProjectReferencesTableViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferenceInTextTableViewCell.h"
#import "Project.h"
#import "Reference.h"
#import "ReferencingApp.h"
#import "LoadingView.h"
#import <MessageUI/MessageUI.h>
#import "ProjectSelectorViewController.h"

@interface ProjectReferencesTableViewController : UITableViewController <SlideableCellDelegate, ReferencingAppNetworkDelegate, MFMailComposeViewControllerDelegate, ProjectSelectorDelegate>
{
    NSArray *refArray;
    NSArray *referenceTypeArray;
    Reference *selectedRef;
    NSIndexPath *selectedIndexPath;
    LoadingView *loadingView;
    Project *selectedOnlineProject;
    UIRefreshControl *refreshControl;
}

@property (nonatomic,retain) Project *currentProject;
@property (strong,nonatomic) NSString *str_Selected_Style;

- (IBAction)addButtonPressed:(id)sender;

@end

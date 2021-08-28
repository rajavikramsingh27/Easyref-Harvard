//
//  ISBNViewController.h
//  EasyRef
//
//  Created by Radu Mihaiu on 24/11/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReferencingApp.h"
#import "LoadingView.h"
#import "ProjectSelectorViewController.h"

@interface ISBNViewController : UIViewController < UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate , ReferencingAppNetworkDelegate, ProjectSelectorDelegate >
{
    LoadingView *loadingView;
    UIBarButtonItem *doneButton;
    int selectedIndex;
    Project *selectedOnlineProject;
    NSString *savedDataString;
}

@property (nonatomic) bool linkedScan;

@property (strong, nonatomic) NSArray *bookEntries;
@property (strong , nonatomic) NSString *scanString;

@property (strong, nonatomic) Project *currentProject;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

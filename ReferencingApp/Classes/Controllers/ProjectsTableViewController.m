//
//  ProjecsTableViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 14/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "ProjectsTableViewController.h"
#import "AppDelegate.h"
#import "ProjectReferencesTableViewController.h"
#import "IndexViewController.h"
#import "SettingsTableViewController.h"
#import "NSAttributedString+Ashton.h"
#import "CreateReference_VC/CreateReference_ViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CreateReference_VC/CreateReference_ViewController.h"


@import MobileCoreServices;


@interface ProjectsTableViewController () <UIPickerViewDelegate , UIPickerViewDataSource>
@property (strong) NSMutableArray *arr_Style_Picker;

@end

@implementation ProjectsTableViewController {
    NSMutableDictionary *dict_Styles;
    NSString *str_ProjectName;
    NSString *str_Project_Styles;
    bool is_Update;
    int index_update;
    
    NSArray *arr_project_Selected;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    is_Update = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(func_settings:) name:@"setting_ProjectReference" object:nil];
    
    dict_Styles = [[NSMutableDictionary alloc]init];
    
    [self.view_White_Styles.layer setCornerRadius:2];
    [self.view_White_Styles setClipsToBounds:YES];
    
    [self func_get_styles];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
    
    newCell = false;
    
    [_createLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
    [_projectButton.titleLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([ReferencingApp sharedInstance].isOffline == false) {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:refreshControl];
    }
    
    
}

-(void)func_cancel_pikcerView {
    [self.view endEditing:YES];
    [self.view_Styles setHidden:YES];
}

-(void)startRefresh {
  if ([ReferencingApp sharedInstance].isOffline == false) {
    self.tableView.userInteractionEnabled = false;
    [[ReferencingApp sharedInstance] getUserData];
  }
}

-(void)loginFailedWithError:(NSString *)errorString {
  self.tableView.userInteractionEnabled = true;
  [refreshControl endRefreshing];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
  [alertView show];
}

-(void)userSyncComplete {
  self.tableView.userInteractionEnabled = true;
  [refreshControl endRefreshing];
  [self.tableView reloadData];
}

-(void)hideNavBar
{
    [self.tableView setContentInset:UIEdgeInsetsMake(43, 0, 0, 0)];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

-(void)showNavBar
{
    [self.tableView setContentInset:UIEdgeInsetsMake(19, 0, 0, 0)];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if(_openProjectCreation == TRUE && [ReferencingApp sharedInstance].isOffline == FALSE  && _secondLevel != TRUE)
    {
        _openProjectCreation = false;
        ProjectsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"projectsVC"];
        vc.openProjectCreation = TRUE;
        vc.secondLevel = TRUE;
        vc.showingOnlineProjects = TRUE;
        
        [self.navigationController pushViewController:vc animated:TRUE];
        
    }
    else if (_openProjectCreation == TRUE && [ReferencingApp sharedInstance].isOffline == FALSE  && _secondLevel != TRUE)
    {
        _openProjectCreation = false;
        [self newProjectButtonPressed:nil];

    }
    else if (_openProjectCreation == TRUE)
    {
        _openProjectCreation = false;
        [self newProjectButtonPressed:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self setTabBarVisible:true animated:true];
    
    [self.view_Styles setHidden:YES];
    self.txt_Styles.text = @"";
    
    index_update = 0;
    
    projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
    [ReferencingApp sharedInstance].delegate = self;
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavBar) name:@"hideNavBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBar) name:@"showNavBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:@"showSettings" object:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.70f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.50f];
    
    if ([ReferencingApp sharedInstance].isOffline == FALSE && _secondLevel != TRUE)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.tableView.tableHeaderView = nil;
    }
    
    if ([ReferencingApp sharedInstance].isOffline == TRUE)
    {
        if ([projectsArray count] > 1)
            self.tableView.tableHeaderView = nil;
    }
    else if ([ReferencingApp sharedInstance].isOffline == FALSE && _secondLevel == TRUE)
    {
        if (_showingOnlineProjects == TRUE)
        {
            if ([[ReferencingApp sharedInstance].onlineProjectsArray count] > 1)
                self.tableView.tableHeaderView = nil;
        }
        else
        {
            if ([projectsArray count] > 1)
                self.tableView.tableHeaderView = nil;
            
        }
    }

    
    if (_secondLevel == TRUE)
    {
        [[IndexViewController sharedIndexVC] hideTopMenu];
    }
    else
    {
        [[IndexViewController sharedIndexVC] showTopMenuWithString:@"Projects"];
    }

    self.view_Styles.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    UIPickerView *objPickerView = [UIPickerView new];
    
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *btn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(func_cancel_pikcerView)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(func_Done_PickerView)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:btn_cancel,space,doneBtn, nil]];
    
    [self.txt_Styles setInputAccessoryView:toolBar];
    
    self.txt_Styles.inputView = objPickerView;
    
    [self.view addSubview:self.view_Styles];
    
}


- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"referencesSegue"]) {
        ProjectReferencesTableViewController *vc  = segue.destinationViewController;
        vc.title = selectedProject.name;
        vc.currentProject = selectedProject;
        
        NSDictionary *dict_Def_Styles = [[NSUserDefaults standardUserDefaults] objectForKey:@"styles"];
        if (dict_Def_Styles != nil) {
            if (selectedProject.name != nil) {
                vc.str_Selected_Style =  [NSString stringWithFormat:@"%@",[dict_Def_Styles objectForKey:selectedProject.name]];
            }
        }
    }
}

-(void)showSettings
{
    [self performSelector:@selector(goToSettings) withObject:nil afterDelay:0.3f];
}

-(void)goToSettings
{
    [self showNavBar];
    SettingsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsVC"];
    [self.navigationController pushViewController:vc animated:TRUE];
    
}


#pragma mark - Table view data source


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *footerImage = [[UIImageView alloc] initWithFrame:footerView.bounds];
    [footerImage setImage:[UIImage imageNamed:@"project_separator.png"]];
    [footerView addSubview:footerImage];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_secondLevel == TRUE)
    {
        if (_showingOnlineProjects == TRUE)
            return [[ReferencingApp sharedInstance].onlineProjectsArray count];
        else
            return  [projectsArray count];

    }
    
    if( [ReferencingApp sharedInstance].isOffline == FALSE)
       return 2;
   
    // Return the number of rows in the section.
    return  [projectsArray count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE) {
        ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
        
        if (newCell == false) {
            Project *project = [[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row];
            
            cell.projectTextField.text = project.name;
            cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[project.references count]];
        } else {
            cell.projectTextField.text = @"";
            cell.numberLabel.text = @"0";
            [cell goToEditMode];
            editingCell = cell;
        }
        cell.delegate = self;
        return cell;
    }
    else if( [ReferencingApp sharedInstance].isOffline == FALSE && _secondLevel != TRUE) {
        ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
        [cell.coverView removeGestureRecognizer:cell.panGesture];
        if (indexPath.row == 0)
        {
            cell.projectTextField.text = [ReferencingApp sharedInstance].user.name;
            cell.numberLabel.text = [NSString stringWithFormat:@"%i",[[ReferencingApp sharedInstance].onlineProjectsArray count]];
        } else {
            cell.projectTextField.text = @"Local";
            cell.numberLabel.text = [NSString stringWithFormat:@"%i",[projectsArray count]];
        }
        return cell;
    }
    
    ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
    
    if (newCell == false)
    {
        Project *project = [projectsArray objectAtIndex:indexPath.row];
        
        cell.projectTextField.text = project.name;
        cell.numberLabel.text = [NSString stringWithFormat:@"%i",[project.references count]]; 
    }
    else
    {
        cell.projectTextField.text = @"";
        cell.numberLabel.text = @"0";
        [cell goToEditMode];
        editingCell = cell;
    }
    
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingCell != nil)
        return;
    
    if( [ReferencingApp sharedInstance].isOffline == FALSE && _secondLevel != TRUE) {
        ProjectsTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"projectsVC"];
        vc.secondLevel = TRUE;
        
        if (indexPath.row == 0)
            vc.showingOnlineProjects = TRUE;
        else
            vc.showingOnlineProjects = FALSE;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    else    {
        if (_secondLevel == TRUE && _showingOnlineProjects == TRUE)
            selectedProject = [[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row];
        else
            selectedProject = [projectsArray objectAtIndex:indexPath.row];
        
        [self performSegueWithIdentifier:@"referencesSegue" sender:self];
    }
}



- (IBAction)addButtonPressed:(id)sender {
    [self.view_Styles setHidden:NO];
    [self.txt_Styles becomeFirstResponder];
    
    is_Update = NO;
    
//    [[IndexViewController sharedIndexVC] hideTopMenu];
//
//    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
//
//    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE)
//    {
//
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
//        Project *newProject = [[Project alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
//        newProject.onlineProject = [NSNumber numberWithBool:TRUE];
//        [[ReferencingApp sharedInstance].onlineProjectsArray insertObject:newProject atIndex:0];
//        selectedProject = newProject;
//
//    }
//    else
//    {
//
//        Project *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
//        newProject.onlineProject = [NSNumber numberWithBool:FALSE];
//        newProject.dateCreated = [NSDate date];
//        selectedProject = newProject;
//
//        projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
//    }
//
//
//    newCell = true;
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//
}

- (IBAction)newProjectButtonPressed:(id)sender
{
    self.tableView.tableHeaderView = nil;
    [self addButtonPressed:nil];
}


-(void)unloadLoadingView
{
    
    [UIView animateWithDuration:0.5f animations:^{
        loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
        loadingView = nil;

    }];
}

#pragma mark REFERECING APP NETWORK DELEGATE

-(void)projectEditingFailedWithError:(NSString *)errorString
{
    
    [self unloadLoadingView];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: nil
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
    [alert show];

}

-(void)projectScuessfullyEdited
{
    
    NSLog(@"name before - %@",selectedProject.name);
    
    selectedProject.name = editingCell.projectTextField.text;
    
    NSLog(@"name after - %@",selectedProject.name);

    selectedProject = nil;
    editingCell = nil;
    newCell = false;
    
    
    
    [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];

    
    [self unloadLoadingView];
}

-(void)projectDeletionFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles: nil];
    [alert show];

}

-(void)projectSucessfullyDeleted
{
    [[ReferencingApp sharedInstance].onlineProjectsArray removeObject:selectedProject];
    selectedProject = nil;
    
    [self.tableView deleteRowsAtIndexPaths:@[deleteIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    deleteIndexPath = nil;

    [self unloadLoadingView];
    
}

-(void)projectCreationFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: nil
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
    [alert show];
    
}

-(void)projectSucessfullyCreatedWithData:(NSDictionary *)dictionary
{
    selectedProject.projectID = [[dictionary objectForKey:@"id"] stringValue];
    selectedProject.name = [dictionary objectForKey:@"name"];
    
    
    [editingCell endEditing];
    [self unloadLoadingView];
    
}


#pragma mark SLIDEABLE CELL DELEGATE METHODS

-(BOOL)canSlide
{
    if (editingCell != nil)
        return NO;
    else
        return YES;
}

-(void)deleteButtonPressedAtCell:(ProjectTableViewCell *)cell {
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE) {
        if (newCell == TRUE) {
            newCell = false;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [[ReferencingApp sharedInstance].onlineProjectsArray removeObjectAtIndex:indexPath.row];
            selectedProject = nil;
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            deleteIndexPath = nil;
            
            [self unloadLoadingView];
            
            [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];

            return;
        }
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        deleteIndexPath = indexPath;
        
        Project *proj = [[[ReferencingApp sharedInstance] onlineProjectsArray] objectAtIndex:indexPath.row];
        selectedProject = proj;
        
        [[ReferencingApp sharedInstance] deleteProjectWithID:proj.projectID];
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];

        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"index path is:- %li",(long)indexPath.row);
    
    Project *project = [projectsArray objectAtIndex:indexPath.row];
    NSLog(@"%@",project.name);
    if (project.name != nil) {
        [dict_Styles removeObjectForKey:project.name];
        [[NSUserDefaults standardUserDefaults]setObject:dict_Styles forKey:@"styles"];
    }
    
    [self deleteProject:[projectsArray objectAtIndex:indexPath.row]];
    projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)exportButtonPressedAtCell:(ProjectTableViewCell *)cell {
    editingCell = cell;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to include in-text references ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: @"No", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        [self setupExportEmailWithInTextRefrences:true];
    else
        [self setupExportEmailWithInTextRefrences:false];
}

-(void)setupExportEmailWithInTextRefrences:(BOOL)inTextReferences {
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:editingCell];
    editingCell = nil;

    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE)
        selectedProject = [[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row];
    else
        selectedProject = [projectsArray objectAtIndex:indexPath.row];
    
    NSMutableAttributedString *mailString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSArray *refArray =  [[selectedProject.references allObjects] sortedArrayUsingComparator:^NSComparisonResult(Reference *p1, Reference *p2){
        
        return [[[p1 getReferenceString] string] compare:[[p2 getReferenceString] string] options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
        
    }];
    
    
    for (Reference *ref in refArray)
    {
        [mailString appendAttributedString:[ref getReferenceString]];
        if (inTextReferences == true) {
            [mailString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
            [mailString appendAttributedString:[[NSAttributedString alloc] initWithString:[ref getShortReferenceString]]];
        }
        [mailString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n\n"]];
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
   if ([MFMailComposeViewController canSendMail]) {

    
    if ([ReferencingApp sharedInstance].user.isLoggedIn == true)
        [mc setToRecipients:[NSArray arrayWithObject:[ReferencingApp sharedInstance].user.email]];
    
    mc.mailComposeDelegate = self;
    [mc setMessageBody:[mailString mn_HTMLRepresentation] isHTML:YES];
    [mc setSubject:[NSString stringWithFormat:@"%@ References",selectedProject.name]];
    [self presentViewController:mc animated:YES completion:NULL];
}
    }

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
            
    }
    
    selectedProject = nil;
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(void)editButtonPressedAtCell:(ProjectTableViewCell *)cell {
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    preEditString = cell.projectTextField.text;
    editingCell = cell;
    
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE)
        selectedProject = [[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row];
    else
        selectedProject = [projectsArray objectAtIndex:indexPath.row];
    
    [self addEditingNavItem];
}

-(void)func_settings:(NSNotification*)sender {
    is_Update = YES;
    [self.view_Styles setHidden:NO];
    [self.txt_Styles becomeFirstResponder];
    
    ProjectTableViewCell *cell = sender.object;
    str_ProjectName = cell.projectTextField.text;
    
    NSDictionary *dict_Def_Styles = [[NSUserDefaults standardUserDefaults] objectForKey:@"styles"];
    NSString *str_Selected_Styles = [NSString stringWithFormat:@"%@",[dict_Def_Styles objectForKey:cell.projectTextField.text]];
    
    if (str_Selected_Styles != nil) {
        self.txt_Styles.text = str_Selected_Styles;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    arr_project_Selected = [self updateReferenceArray:[projectsArray objectAtIndex:indexPath.row]];
}

-(void)func_Update {
    NSDictionary *dict_Def_Styles = [[NSUserDefaults standardUserDefaults] objectForKey:@"styles"];
    if (dict_Def_Styles != nil) {
        dict_Styles = [dict_Def_Styles mutableCopy];
    }
    [dict_Styles setObject:self.txt_Styles.text forKey:str_ProjectName];
    [[NSUserDefaults standardUserDefaults]setObject:dict_Styles forKey:@"styles"];
    
    [self func_save_APII];
}

-(void) func_save_APII {
    if (arr_project_Selected.count < index_update) {
        return;
    }
    
    
    Reference *ref = [arr_project_Selected objectAtIndex:index_update];
    NSMutableDictionary *refDataDictionary=[NSJSONSerialization JSONObjectWithData:[ref.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    [self func_save_API:refDataDictionary ref:ref];
    index_update=index_update+1;
}

-(void)func_save_API:(NSDictionary*)refDataDictionary ref:(Reference*)ref {
    NSArray *arr_AutherField = [refDataDictionary objectForKey:@"Author Double Field"];
    NSString *str_firstName = [[arr_AutherField objectAtIndex:0] objectForKey:@"Initials"];
    NSString *str_lastname = [[arr_AutherField objectAtIndex:0] objectForKey:@"Surname"];
    
    NSString *str_BLOG_TITLE = [refDataDictionary objectForKey:@"Blog Title"];
    NSString *str_DATE_ACCESSED_VIEWED = [refDataDictionary objectForKey:@"Accessed Date"];
    NSString *str_DATE_PUBLISHED = [refDataDictionary objectForKey:@"Date of Post"];
    NSString *str_TITLE_OF_POST = [refDataDictionary objectForKey:@"Title of blog entry"];
    NSString *str_URL = [refDataDictionary objectForKey:@"URL"];
    
    NSMutableDictionary *dic_JSON = [[NSMutableDictionary alloc]init];
    
    [dic_JSON setObject:@"ITEM-1" forKey:@"id"];
    [dic_JSON setObject:@"post-weblog" forKey:@"type"];
    
    NSDictionary *dict_Author = @{@"family":str_firstName,@"given":str_lastname};
    NSArray *arr_Author = @[dict_Author];
    [dic_JSON setObject:arr_Author forKey:@"author"];
    
    NSArray *arr_DateAccessed = [str_DATE_ACCESSED_VIEWED componentsSeparatedByString:@","];
    NSArray *arr_DateParts = @[arr_DateAccessed];
    NSDictionary *dict_Dateparts = @{@"date-parts":arr_DateParts};
    [dic_JSON setObject:dict_Dateparts forKey:@"issued"];
    [dic_JSON setObject:str_TITLE_OF_POST forKey:@"title"];
    [dic_JSON setObject:str_BLOG_TITLE forKey:@"container-title"];
    [dic_JSON setObject:str_URL forKey:@"URL"];
    
    NSArray *arr_DatePublished = [str_DATE_PUBLISHED componentsSeparatedByString:@","];
    
    NSArray *arr_DateParts_Accessed = @[arr_DatePublished];
    NSDictionary *dict_Dateparts_Accessed = @{@"date-parts":arr_DateParts_Accessed};
    
    [dic_JSON setObject:dict_Dateparts_Accessed forKey:@"accessed"];
    
    NSArray *arr_JSON = [NSArray arrayWithObject:dic_JSON];
    NSLog(@"%@",arr_JSON);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr_JSON options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self func_POST_API:jsonString ref:ref];
}

-(NSArray*)updateReferenceArray:(Project*)project_Selected {
    return [[project_Selected.references allObjects] sortedArrayUsingComparator:^NSComparisonResult(Reference *p1, Reference *p2){
        
        NSString *str1 = [p1 getShortReferenceString];
        NSString *str2 = [p2 getShortReferenceString];
        
        if(str1 != nil && str1.length > 0) {
            if(str2 != nil && str2.length > 0) {
                return [[str1 substringWithRange:NSMakeRange(1, 1)] compare:[str2 substringWithRange:NSMakeRange(1, 1)]];
            }
            else{
                return [[str1 substringWithRange:NSMakeRange(1, 1)] compare:@""];
            }
        }
        else{
            
            return [@"" compare:[str2 substringWithRange:NSMakeRange(1, 1)]];
        }
        
    }];
}

-(void)editingFinishedAtCell:(ProjectTableViewCell *)cell {
    if ([editingCell.projectTextField.text isEqualToString:@""] || [editingCell.projectTextField.text isEqualToString:@"Uncategorized"])
    {
        [editingCell shake];
        return;
    }
    
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE && newCell == false)
    {
        if (dontCallEditing == TRUE)
        {
            dontCallEditing = false;
            [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];
            return;
        }
        
        if ([preEditString isEqualToString:editingCell.projectTextField.text])
        {
            [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];
            selectedProject = nil;
            editingCell = nil;
            newCell = false;

            return;
        }
        
        
        [[ReferencingApp sharedInstance] editProjectWithID:selectedProject.projectID andNewName:editingCell.projectTextField.text];
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];

        return;
    }
    
    selectedProject.name = editingCell.projectTextField.text;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
   
    selectedProject = nil;
    editingCell = nil;
    newCell = false;
    
    if ( _secondLevel != TRUE)
        [[IndexViewController sharedIndexVC] showTopMenuWithString:@"Projects"];


    [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];

}

-(void)addEditingNavItem
{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)] animated:true];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)] animated:TRUE];

}


-(void)cancelPressed {
    [self.view endEditing:YES];
    [self.view_Styles setHidden:YES];
    
    if (newCell == TRUE) {
        if(_secondLevel == TRUE && _showingOnlineProjects == TRUE) {
            [editingCell.projectTextField resignFirstResponder];
            
            [self deleteButtonPressedAtCell:editingCell];
            editingCell = nil;
            
            return;
        }
        projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
        
        [editingCell.projectTextField resignFirstResponder];
        newCell = false;
        [self deleteButtonPressedAtCell:editingCell];
        editingCell = nil;
        
        [self.navigationItem setLeftBarButtonItem:nil animated:TRUE];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] animated:TRUE];
        
        if ( _secondLevel != TRUE)
            [[IndexViewController sharedIndexVC] showTopMenuWithString:@"Projects"];
        
        return;
    }
    else
    {
        if(_secondLevel == TRUE && _showingOnlineProjects == TRUE)
            dontCallEditing = TRUE;
        
        editingCell.projectTextField.text = preEditString;
        [editingCell endEditing];
    }
    
    editingCell = nil;
}

-(void)donePressed {
    self.tableView.userInteractionEnabled = true;
    str_ProjectName = editingCell.projectTextField.text;
    
    if ([editingCell.projectTextField.text isEqualToString:@""] || [editingCell.projectTextField.text isEqualToString:@"Uncategorized"])
    {
        [editingCell shake];
        return;
    }
    
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE && newCell == TRUE)
    {
        [[ReferencingApp sharedInstance] createProjectWithName:editingCell.projectTextField.text];
        
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];
        
        return;
    }
    [editingCell endEditing];
    
    NSDictionary *dict_Def_Styles = [[NSUserDefaults standardUserDefaults] objectForKey:@"styles"];
    if (dict_Def_Styles != nil) {
        dict_Styles = [dict_Def_Styles mutableCopy];
    }
    [dict_Styles setObject:self.txt_Styles.text forKey:str_ProjectName];
    [[NSUserDefaults standardUserDefaults]setObject:dict_Styles forKey:@"styles"];
}

-(void)deleteProject:(Project *)project {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    [managedObjectContext deleteObject:project];
    [appDelegate saveContext];
}

-(void)func_Done_PickerView {
    if ([self.txt_Styles.text isEqualToString:@""]) {
        return;
    }
    
//    NSDictionary *dict_Def_Styles = [[NSUserDefaults standardUserDefaults] objectForKey:@"styles"];
//    if (dict_Def_Styles != nil) {
//        dict_Styles = [dict_Def_Styles mutableCopy];
//    }
//    [dict_Styles setObject:self.txt_Styles.text forKey:str_ProjectName];
//    [[NSUserDefaults standardUserDefaults]setObject:dict_Styles forKey:@"styles"];
    
    [self.view endEditing:YES];
    [self.view_Styles setHidden:YES];
    
    if (is_Update == YES) {
        [self func_Update];
        return;
    }
    
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    if (_secondLevel == TRUE && _showingOnlineProjects == TRUE) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
        Project *newProject = [[Project alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        newProject.onlineProject = [NSNumber numberWithBool:TRUE];
        [[ReferencingApp sharedInstance].onlineProjectsArray insertObject:newProject atIndex:0];
        selectedProject = newProject;
    } else {
        Project *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:managedObjectContext];
        newProject.onlineProject = [NSNumber numberWithBool:FALSE];
        newProject.dateCreated = [NSDate date];
        selectedProject = newProject;
        projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
    }
    
    newCell = true;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _arr_Style_Picker.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arr_Style_Picker[row] uppercaseString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@",self.arr_Style_Picker[row]);
    self.txt_Styles.text = self.arr_Style_Picker[row];
}


-(void) func_get_styles {
    self.arr_Style_Picker = [[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *full_URL = [NSString stringWithFormat:@"http://ondemandcab.com/appentus_food/api/csl_v1/get_styles"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:full_URL]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //        NSLog(@"httpResponse is:- %ld",(long)httpResponse.statusCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSInteger success = [[responseDictionary objectForKey:@"status"] integerValue];
            if(success == 1) {
                NSArray *arrStyles = [responseDictionary objectForKey:@"styles"];
                for (NSString *strStyle in arrStyles) {
                    NSMutableString *strStyle_Filter = [[NSMutableString alloc]init];
                    strStyle_Filter = [[strStyle stringByReplacingOccurrencesOfString:@"/home/gkax6xpyuge2/public_html/appentus_food/application//../vendor/citation-style-language/styles-distribution/dependent/" withString:@""] mutableCopy];

                    strStyle_Filter = [[strStyle_Filter stringByReplacingOccurrencesOfString:@".csl" withString:@""] mutableCopy];
                    [self.arr_Style_Picker addObject:strStyle_Filter];
                }
            }
        }
    }];
    [dataTask resume];
}



-(void) func_POST_API: (NSString*)json ref:(Reference*)ref {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSDictionary *dict_Param = [[NSDictionary alloc] initWithObjectsAndKeys:
                                json, @"json",
                                self.txt_Styles.text, @"style",
                                nil];
    NSLog(@"dict_Param is- %@",dict_Param);
    NSString *boundary = [self generateBoundaryString];
    
    // configure the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ondemandcab.com/appentus_food/api/csl_v1/get"]];
    [request setHTTPMethod:@"POST"];
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:dict_Param paths:nil fieldName:nil];
    NSURLSession *session = [NSURLSession sharedSession];  // use sharedSession or create your own
    NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSInteger success = [[responseDictionary objectForKey:@"status"] integerValue];
            if(success == 1) {
                NSString *str_result = [responseDictionary objectForKey:@"result"];
                NSLog(@"result is:- %@",str_result);
                
                NSString *str_MSG = [NSString stringWithFormat:@"%@",str_result];
                NSLog(@"%@",str_MSG);
                
                NSArray *refData=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                [self func_Save_Local_DB:[refData objectAtIndex:0] result_API:str_MSG ref:ref];
            } else {
                NSString *str_error = [responseDictionary objectForKey:@"error"];
                NSLog(@"str_error is:- %@",str_error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[IndexViewController sharedIndexVC] error_POPUP:str_error];
                });
            }
        }
    }];
    [task resume];
}



- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}


-(NSAttributedString *)convertHTML:(NSString *)html {
    return [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes:nil error:nil];
}

-(void) func_Save_Local_DB:(NSDictionary*)refDataDictionary result_API:(NSString*)result_API ref:(Reference*)ref {
    NSError *error;
    NSMutableDictionary *dict_refData = [[NSMutableDictionary alloc]init];
    dict_refData = [refDataDictionary mutableCopy];
    [dict_refData setObject:result_API  forKey:@"result_API"];
    
    NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict_refData options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
    
    [[ReferencingApp sharedInstance] editReferenceWithData:dataString referenceType:ref.referenceType projectID:ref.projectID andReferenceID:ref.referenceID];
    
    [self func_save_APII];
}

@end

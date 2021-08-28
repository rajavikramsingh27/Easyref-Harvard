//  ProjectReferencesTableViewController.m
//  ReferencingApp

//  Created by Radu Mihaiu on 19/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.



#import "ProjectReferencesTableViewController.h"
#import "EasyReferencingViewController.h"
#import "CreateReferenceTableViewController.h"
#import "IndexViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "NSAttributedString+Ashton.h"
#import "CreateReference_VC/CreateReference_ViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface ProjectReferencesTableViewController ()

@end

@implementation ProjectReferencesTableViewController

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
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
    [self updateReferenceArray];
    referenceTypeArray = [ReferencingApp sharedInstance].referenceTypeArray;
    
    if ([_currentProject.onlineProject boolValue] == TRUE) {
      refreshControl = [[UIRefreshControl alloc] init];
      [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
      [self.tableView addSubview:refreshControl];
    }
}



-(void)startRefresh {
  self.tableView.userInteractionEnabled = false;
  [[ReferencingApp sharedInstance] getUserData];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ReferencingApp sharedInstance].delegate = self;
    
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    [self updateReferenceArray];
    [self.tableView reloadData];
  
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.70f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.50f];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    selectedRef = nil;
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_currentProject.references count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Reference *currentRef = [refArray objectAtIndex:indexPath.row];
    
    ReferenceInTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
    cell.projectTextField.text = currentRef.referenceType;
    
    NSError *jsonError;
    NSData *objectData = [currentRef.data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    NSString *result_API = [json objectForKey:@"result_API"];
    cell.referenceLabel.attributedText = [self convertHTML:result_API];
    
//    for (NSDictionary *dict in referenceTypeArray) {
//        if ([[dict objectForKey:@"name"] isEqualToString:currentRef.referenceType]) {
//            cell.typeImageView.image = [dict objectForKey:@"imgValue"];
//            cell.typeImageView.backgroundColor =  UIColorFromRGB([[dict objectForKey:@"colorValue"] intValue]);
//            cell.referenceLabel.attributedText = [currentRef getReferenceString];
//            cell.intextReferenceLabel.text = [currentRef getShortReferenceString];
//        }
//    }
//    cell.referenceLabel.attributedText =
    
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)deleteButtonPressedAtCell:(ProjectTableViewCell *)cell {
    if ([_currentProject.onlineProject boolValue] == TRUE) {
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        selectedRef = [refArray objectAtIndex:indexPath.row];
        selectedIndexPath = indexPath;
        
        [[ReferencingApp sharedInstance] deleteReferenceWithID:selectedRef.referenceID];
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self deleteReference:[refArray objectAtIndex:indexPath.row]];
    [self updateReferenceArray];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void)exportButtonPressedAtCell:(ProjectTableViewCell *)cell
{
  
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  
  selectedRef = [refArray objectAtIndex:indexPath.row];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to include in-text reference ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: @"No", nil];
  [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0)
    [self exportSelectedRefWithInTextReference:true];
  else
    [self exportSelectedRefWithInTextReference:false];
}


-(void)exportSelectedRefWithInTextReference:(BOOL)inTextReference
{
  
  if (selectedRef == nil)
    return;
  
  NSMutableAttributedString *mailString = [[NSMutableAttributedString alloc] initWithString:@""];
  
  if (inTextReference) {
    [mailString appendAttributedString:[[NSAttributedString alloc] initWithString:[selectedRef getShortReferenceString]]];
    [mailString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
  }
  
  [mailString appendAttributedString:[selectedRef getReferenceString]];
  
  MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    
    if ([MFMailComposeViewController canSendMail]) {
  
  if ([ReferencingApp sharedInstance].user.isLoggedIn == true)
    [mc setToRecipients:[NSArray arrayWithObject:[ReferencingApp sharedInstance].user.email]];
  
  NSLog(@"%@",[mailString string]);
  
  mc.mailComposeDelegate = self;
  [mc setSubject:[NSString stringWithFormat:@"Reference"]];
  [mc setMessageBody:[mailString mn_HTMLRepresentation] isHTML:YES];
  [self presentViewController:mc animated:YES completion:NULL];
        
    }
}

-(void)projectSelectorDidSelectProject:(Project *)project {
  
  // both online
  if ([_currentProject.onlineProject boolValue] == true && [project.onlineProject boolValue] == true) {
    selectedOnlineProject = project;
    if (selectedOnlineProject.name == _currentProject.name)
      return;
    
    loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    [self.view.window addSubview:loadingView];
    [loadingView fadeIn];
    
    [[ReferencingApp sharedInstance] switchReferenceWithID:selectedRef.referenceID andType:selectedRef.referenceType toProject:selectedOnlineProject.projectID];
    return;
  }
  // both offline
  if ([_currentProject.onlineProject boolValue] == false && [project.onlineProject boolValue] == false) {
    if (project.name == _currentProject.name)
      return;
    
    [_currentProject removeReferencesObject:selectedRef];
    [project addReferencesObject:selectedRef];
    [[ReferencingApp sharedInstance] saveDatabase];
    
    [self updateReferenceArray];
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    return;
  }
  
  
  // online -> offline
  if ([_currentProject.onlineProject boolValue] == true) {
    [[ReferencingApp sharedInstance] deleteReferenceWithID:selectedRef.referenceID];
    
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    Reference *newRef = [NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:managedObjectContext];
    
    newRef.dateCreated = selectedRef.dateCreated;
    newRef.data = selectedRef.data;
    newRef.referenceType = selectedRef.referenceType;
    [project addReferencesObject:newRef];
    [[ReferencingApp sharedInstance] saveDatabase];
    [self.tableView reloadData];
  }
  //offline -> online
  else {
    selectedOnlineProject = project;
    loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    [self.view.window addSubview:loadingView];
    [loadingView fadeIn];
    
    [[ReferencingApp sharedInstance] createReferenceWithData
     :selectedRef.data referenceType:selectedRef.referenceType andProjectID:project.projectID];
    [_currentProject removeReferencesObject:selectedRef];
    [[ReferencingApp sharedInstance] saveDatabase];
    
    [self updateReferenceArray];
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
  }
}

-(void)referenceSucessfullyCreated:(NSDictionary *)dictionary
{
  
  AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
  NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
  
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:managedObjectContext];
  Reference *newRef = [[Reference alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
  
  newRef.projectID = [[dictionary objectForKey:@"project_id"] stringValue];
  newRef.referenceType = [dictionary objectForKey:@"reference_type"];
  newRef.data = [dictionary objectForKey:@"data"];
  newRef.referenceID = [[dictionary objectForKey:@"id"] stringValue];
  
  NSString *dateString = [dictionary objectForKey:@"created_at"];
  dateString = [dateString substringToIndex:[dateString length]-5];
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-M-d'T'H:m:s"];
  
  newRef.dateCreated = [dateFormat dateFromString:dateString];
  [selectedOnlineProject addReferencesObject:newRef];
  [self unloadLoadingView];
  
  NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
  for (UIViewController *aViewController in allViewControllers) {
    if ([aViewController isKindOfClass:[ProjectReferencesTableViewController class]]) {
      [[IndexViewController sharedIndexVC] saveSucessfull];
      
      [self.navigationController popToViewController:aViewController animated:TRUE];
      return;
      
    }
  }
}

-(void)referenceCreationFailedWithEror:(NSString *)errorString
{
  [self unloadLoadingView];
  
  
  UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                 message: errorString
                                                delegate: self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
  [alert show];
}


-(void)editButtonPressedAtCell:(ProjectTableViewCell *)cell
{
  
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  selectedRef = [refArray objectAtIndex:indexPath.row];
  selectedIndexPath = indexPath;
  
  ProjectSelectorViewController *selector = [self.storyboard instantiateViewControllerWithIdentifier:@"projectSelectorVC"];
  selector.delegate = self;
  [self presentViewController:selector animated:true completion:nil];

}

/*-(void)updateReferenceArray {
  refArray =  [[_currentProject.references allObjects] sortedArrayUsingComparator:^NSComparisonResult(Reference *p1, Reference *p2){
    
    return [[[p1 getShortReferenceString] substringWithRange:NSMakeRange(1, 1)] compare:[[p2 getShortReferenceString] substringWithRange:NSMakeRange(1, 1)]];
  }];
}*/

-(void)updateReferenceArray {
    refArray =   [[_currentProject.references allObjects] sortedArrayUsingComparator:^NSComparisonResult(Reference *p1, Reference *p2){
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"typeSelectSegue"])
    {
        EasyReferencingViewController *vc = segue.destinationViewController;
        vc.currentProject = _currentProject;
        vc.str_Selected_Style = self.str_Selected_Style;
        vc.title = @"Type select";
    }
    if ([segue.identifier isEqualToString:@"referenceDetailSegue1"])
    {
//        CreateReferenceTableViewController *vc = segue.destinationViewController;
        CreateReference_ViewController *vc = segue.destinationViewController;
        vc.title = selectedRef.referenceType;
        vc.currentProject = _currentProject;
        vc.currentReference = selectedRef;
        vc.str_Selected_Style = self.str_Selected_Style;
        
        for (NSDictionary *dict in referenceTypeArray)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:selectedRef.referenceType])
            {
                vc.view.tintColor = UIColorFromRGB([[dict objectForKey:@"colorValue"] intValue]);
            }
            
        }
        
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRef = [refArray objectAtIndex:indexPath.row];
    selectedIndexPath = indexPath;
//    [self performSegueWithIdentifier:@"referenceDetailSegue" sender:self];
    [self performSegueWithIdentifier:@"referenceDetailSegue1" sender:self];
}

-(void)deleteReference:(Reference *)reference
{
    [_currentProject removeReferencesObject:reference];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    [managedObjectContext deleteObject:reference];
    [appDelegate saveContext];
}

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


#pragma mark REFERENCING APP NETWORK DELEGATE

-(void)switchSuccessfull
{
    [_currentProject removeReferencesObject:selectedRef];
    [selectedOnlineProject addReferencesObject:selectedRef];
    selectedRef = nil;
    
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self updateReferenceArray];
    [self.tableView reloadData];
  
    selectedIndexPath = nil;
    
    [self unloadLoadingView];
}

-(void)switchFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)referenceSucessfullyDeleted
{
    [_currentProject removeReferencesObject:selectedRef];
    selectedRef = nil;
    
    [self.tableView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self updateReferenceArray];
    [self.tableView reloadData];
  
    selectedIndexPath = nil;
    
    [self unloadLoadingView];

}

-(void)referenceDeletionFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];

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



-(NSAttributedString *)convertHTML:(NSString *)html {
    return [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUTF8StringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                      NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                 documentAttributes:nil error:nil];
    
    
    //    NSScanner *myScanner;
    //    NSString *text = nil;
    //    myScanner = [NSScanner scannerWithString:html];
    //
    //    while ([myScanner isAtEnd] == NO) {
    //
    //        [myScanner scanUpToString:@"<" intoString:NULL] ;
    //
    //        [myScanner scanUpToString:@">" intoString:&text] ;
    //
    //        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    //    }
    //    //
    //    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //    return html;
}

- (IBAction)addButtonPressed:(id)sender {
    
}

@end

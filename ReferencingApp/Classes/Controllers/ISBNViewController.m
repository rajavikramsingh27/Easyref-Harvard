//
//  ISBNViewController.m
//  EasyRef
//
//  Created by Radu Mihaiu on 24/11/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "ISBNViewController.h"
#import "BookTableViewCell.h"
#import "IndexViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

@implementation ISBNViewController

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


-(void)viewDidLoad
{
    [super viewDidLoad];
 
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;

    self.bookEntries = [[NSArray alloc] init];
    self.textField.delegate = self;
    
    
    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addReference)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.tableView respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        self.tableView.estimatedRowHeight = 65.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
}


- (BOOL)respondsToSelector:(SEL)selector
{
    static BOOL useSelector;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        useSelector = SYSTEM_VERSION_LESS_THAN(@"8.0");
    });
    
    if (selector == @selector(tableView:heightForRowAtIndexPath:))
    {
        return useSelector;
    }
    
    return [super respondsToSelector:selector];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ReferencingApp sharedInstance].delegate = self;
    
    if (![_scanString isEqualToString:@""])
    {
        _textField.text = _scanString;
        [[ReferencingApp sharedInstance] searchBooksWithISBN:_scanString];
        
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];

    }
    
}

-(void)addReference
{
    
    loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    [self.view.window addSubview:loadingView];
    [loadingView fadeIn];

    NSDictionary *bookDict = [_bookEntries objectAtIndex:selectedIndex];
    [[ReferencingApp sharedInstance] getBookWithIdentifier:[[bookDict objectForKey:@"recordIdentifier"] objectForKey:@"text"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bookEntries count];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [self.navigationItem setRightBarButtonItem:doneButton];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell" forIndexPath:indexPath];
    
    NSDictionary *bookDict = [_bookEntries objectAtIndex:indexPath.row];
    cell.bookLabel.text = [NSString stringWithFormat:@"%@, %@ ", [[bookDict objectForKey:@"title"] objectForKey:@"text"] , [[[bookDict objectForKey:@"author"] objectForKey:@"name"] objectForKey:@"text"]];

    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    if ([_bookEntries count] == 0)
        return headerView;
    
    UILabel *bookLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, headerView.frame.size.width - 30, 35)];
    [bookLabel setTextColor:[UIColor colorWithRed:20.0f/255.0f green:93.0f/255.0f blue:142/255.0f alpha:1.0f]];
    [bookLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:20.0f]];
    [headerView addSubview:bookLabel];
    
    if ([_bookEntries count] == 1)
        [bookLabel setText:@"Found book:"];
    else
        [bookLabel setText:@"Found books:"];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *bookDict = [_bookEntries objectAtIndex:indexPath.row];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"MuseoSlab-500" size:16.0f]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [[NSString stringWithFormat:@"%@, %@ ", [[bookDict objectForKey:@"title"] objectForKey:@"text"] , [[[bookDict objectForKey:@"author"] objectForKey:@"name"] objectForKey:@"text"]] boundingRectWithSize:CGSizeMake(290, CGFLOAT_MAX)
                                                                                                                                                                                                                  options:(NSStringDrawingUsesLineFragmentOrigin)
                                                                                                                                                                                                               attributes:attributes
                                                                                                                                                                                                                  context:nil];
    //adjust the label the the new height.
    
    return rect.size.height + 20; // we are adding 20 account for the padding;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[ReferencingApp sharedInstance] searchBooksWithISBN:textField.text];
    [textField resignFirstResponder];
    
    loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
    [self.view.window addSubview:loadingView];
    [loadingView fadeIn];

    return TRUE;
}

-(void)searchBooksSucessfullWithData:(NSArray *)array
{
    
    _bookEntries = [[NSArray alloc] initWithArray:array];
    
    [self unloadLoadingView];
    [self.tableView reloadData];
    
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
    [[IndexViewController sharedIndexVC] saveSucessfull];
    [self unloadLoadingView];
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
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


-(void)searchBooksFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}


-(void)getBookSucessfullWithData:(NSString *)dataString
{
  
    [self unloadLoadingView];

    if (self.linkedScan == true)
    {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reference" inManagedObjectContext:managedObjectContext];
        Reference *newRef = [[Reference alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        
        newRef.referenceType = @"Book";
        newRef.projectID = @"0";
        newRef.data = dataString;
        
        newRef.dateCreated = [NSDate date];
        
        [[ReferencingApp sharedInstance].linkedScanRefArray addObject:newRef];
        
        [self.navigationController popViewControllerAnimated:TRUE];

        return;
    }
  
    if (self.currentProject != nil)
      [self createReferenceWithData:dataString andProject:_currentProject];
  
    savedDataString = dataString;
    ProjectSelectorViewController *selector = [self.storyboard instantiateViewControllerWithIdentifier:@"projectSelectorVC"];
    selector.delegate = self;
    [self presentViewController:selector animated:true completion:nil];
}


-(void)projectSelectorDidSelectProject:(Project *)project {
  if ([project.onlineProject boolValue] == true) {
    selectedOnlineProject = project;
    [self createReferenceWithData:savedDataString andProject:selectedOnlineProject];
  }
  else {
    [self createReferenceWithData:savedDataString andProject:project];
  }
  
}


-(void)createReferenceWithData:(NSString *)dataString andProject:(Project *)selectedProject
{
    if ([selectedProject.onlineProject boolValue] == false)
    {
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
        Reference *newRef = [NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:managedObjectContext];
        
        newRef.dateCreated = [NSDate date];
        newRef.data = dataString;
        newRef.referenceType = @"Book";
        
        
        [selectedProject addReferencesObject:newRef];
        
        [[ReferencingApp sharedInstance] saveDatabase];
        [self.navigationController popViewControllerAnimated:TRUE];
        [[IndexViewController sharedIndexVC] saveSucessfull];
    }
    else
        [[ReferencingApp sharedInstance] createReferenceWithData:dataString referenceType:@"Book" andProjectID:selectedProject.projectID];
}
@end

//
//  CreateReferenceTableViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "CreateReferenceTableViewController.h"
#import "SegmentTableViewCell.h"
#import "AppDelegate.h"
#import "ProjectReferencesTableViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

#import "WebDataManager.h"
#import "Utilities.h"
#import "Picker_VC.h"



@interface CreateReferenceTableViewController () <WebDataManagerDelegate>

@end

@implementation CreateReferenceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(picker_Recieve:) name:@"picker_Recieve"  object:nil];
    
    [ReferencingApp sharedInstance].delegate = self;
    
    if ([self.title isEqualToString:@"Blog"] ||
        [self.title isEqualToString:@"Dissertation"] ||
       // [self.title isEqualToString:@"Encyclopedia"] ||
        [self.title isEqualToString:@"Map"] ||
        [self.title isEqualToString:@"Podcast"] ||
        [self.title isEqualToString:@"Powerpoint"] ||
        [self.title isEqualToString:@"Newspaper"]
        )
    {
        singleAuthor = TRUE;
    }
    else
    {
        singleAuthor = FALSE;
    }
    hasEditors = FALSE;

    
    typeData = [ReferencingApp sharedInstance].typeData;
    
   
    
    refDataDictionary  = [[NSMutableDictionary alloc] init];

    
    
    if (_currentReference == nil)
    {
        authorArray = [[NSMutableArray alloc] initWithObjects:[@{@"Surname":@"",@"Initials":@""} mutableCopy], nil];

        for (NSDictionary *dict in typeData)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:self.title])
            {
                typeDictionary = dict;
                
                
                for (NSString *fields in [dict objectForKey:@"fields"])
                {
                    if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                    {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateStyle = NSDateFormatterLongStyle;
                        formatter.timeStyle = NSDateFormatterNoStyle;
                        
                        
                        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                        [refDataDictionary setObject:stringFromDate forKey:fields];
                    }
                    else
                        [refDataDictionary setObject:@"" forKey:fields];

                }
            }
        }
        
        if ([[typeDictionary allKeys] containsObject:@"hasOnline"]) {
            
            
            CGFloat headerHeight;
            if ([self.title isEqualToString:@"Newspaper"] || [self.title isEqualToString:@"Dissertation"])
                headerHeight = 40;
            else
                headerHeight = 80;
            
            headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width,headerHeight)];
            headerView.clipsToBounds = TRUE;
            [headerView setBackgroundColor:[UIColor whiteColor]];
            
            UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Print",@"Online"]];
            segmentControl.selectedSegmentIndex = 0;
            [segmentControl addTarget:self action:@selector(indexChanged:) forControlEvents:UIControlEventValueChanged];
            [segmentControl setFrame:CGRectMake(15, 5, headerView.frame.size.width - 30, 29)];
            [headerView addSubview:segmentControl];
            
            
    
            NSArray *secondItems; 
            if ([self.title isEqualToString:@"Book"])
                secondItems = @[@"Author(s)",@"Editor(s)",@"No Author"];
            else
                secondItems = @[@"Author(s)",@"Editor(s)"];

            UISegmentedControl *secondSegmentControl = [[UISegmentedControl alloc] initWithItems:secondItems];
            secondSegmentControl.selectedSegmentIndex = 0;
            [secondSegmentControl addTarget:self action:@selector(secondIndexChanged:) forControlEvents:UIControlEventValueChanged];
            [secondSegmentControl setFrame:CGRectMake(15, 40, headerView.frame.size.width - 30, 29)];
            [headerView addSubview:secondSegmentControl];

            
            self.tableView.tableHeaderView = headerView;
        }
    }
    else
    {
        NSError *error;
        NSMutableDictionary *refData = [NSJSONSerialization JSONObjectWithData:[_currentReference.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSLog(@"%@",refData);
        
        NSMutableArray *authorArrayData  = [[refData objectForKey:@"Author Double Field"] mutableCopy];
        
        
        authorArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in authorArrayData)
        {
            [authorArray addObject:[[NSMutableDictionary alloc] initWithDictionary:dict]];
        }
        
        
        
        for (NSDictionary *dict in typeData)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:_currentReference.referenceType])
            {
                typeDictionary = dict;
                
                
                for (NSString *fields in [dict objectForKey:@"fields"])
                    [refDataDictionary setObject:[refData objectForKey:fields] forKey:fields];
            }
        }

    }
}

-(void)indexChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.title = [self.title stringByReplacingOccurrencesOfString:@" Online" withString:@""];
            self.title = [self.title stringByReplacingOccurrencesOfString:@" No Author" withString:@""];

            
            CGFloat headerHeight;
            if ([self.title isEqualToString:@"Newspaper"] || [self.title isEqualToString:@"Dissertation"])
                headerHeight = 40;
            else
                headerHeight = 80;
            
            [headerView  setFrame:CGRectMake(0,0,self.tableView.frame.size.width,headerHeight)];
            self.tableView.tableHeaderView = headerView;

            refDataDictionary  = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dict in typeData)
            {
                if ([[dict objectForKey:@"name"] isEqualToString:self.title])
                {
                    typeDictionary = dict;
                    
                    
                    for (NSString *fields in [dict objectForKey:@"fields"])
                    {
                        if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                        {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateStyle = NSDateFormatterLongStyle;
                            formatter.timeStyle = NSDateFormatterNoStyle;
                            
                            
                            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                            [refDataDictionary setObject:stringFromDate forKey:fields];
                        }
                        else
                            [refDataDictionary setObject:@"" forKey:fields];
                        
                    }
                }
            }
            
            [self.tableView reloadData];

            
            break;
        case 1:
            self.title = [self.title stringByReplacingOccurrencesOfString:@" No Author" withString:@""];
            self.title = [self.title stringByAppendingString:@" Online"];
            [headerView  setFrame:CGRectMake(0,0,self.tableView.frame.size.width,40)];
            self.tableView.tableHeaderView = headerView;

            
            refDataDictionary  = [[NSMutableDictionary alloc] init];
            for (NSDictionary *dict in typeData)
            {
                if ([[dict objectForKey:@"name"] isEqualToString:self.title])
                {
                    typeDictionary = dict;
                    
                    
                    for (NSString *fields in [dict objectForKey:@"fields"])
                    {
                        if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                        {
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            formatter.dateStyle = NSDateFormatterLongStyle;
                            formatter.timeStyle = NSDateFormatterNoStyle;
                            
                            
                            NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                            [refDataDictionary setObject:stringFromDate forKey:fields];
                        }
                        else
                            [refDataDictionary setObject:@"" forKey:fields];
                        
                    }
                }
            }
            
            [self.tableView reloadData];
            
            break;
        default: 
            break; 
    }
}

-(void)secondIndexChanged:(UISegmentedControl *)sender
{
    if ([self.title rangeOfString:@"Book"].location == NSNotFound)
    {
        switch (sender.selectedSegmentIndex)
        {
            case 0:
                hasEditors = FALSE;
                break;
            case 1:
                hasEditors = TRUE;
                break;
            default:
                break;
        }
    }
    else
    {
        switch (sender.selectedSegmentIndex)
        {
            case 0:
                self.title = [self.title stringByReplacingOccurrencesOfString:@" No Author" withString:@""];
                hasEditors = FALSE;

                refDataDictionary  = [[NSMutableDictionary alloc] init];
                for (NSDictionary *dict in typeData)
                {
                    if ([[dict objectForKey:@"name"] isEqualToString:self.title])
                    {
                        typeDictionary = dict;
                        
                        
                        for (NSString *fields in [dict objectForKey:@"fields"])
                        {
                            if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                            {
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                formatter.dateStyle = NSDateFormatterLongStyle;
                                formatter.timeStyle = NSDateFormatterNoStyle;
                                
                                
                                NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                                [refDataDictionary setObject:stringFromDate forKey:fields];
                            }
                            else
                                [refDataDictionary setObject:@"" forKey:fields];
                            
                        }
                    }
                }
                
                [self.tableView reloadData];
                break;
            case 1:
                self.title = [self.title stringByReplacingOccurrencesOfString:@" No Author" withString:@""];
                hasEditors = TRUE;

                refDataDictionary  = [[NSMutableDictionary alloc] init];
                for (NSDictionary *dict in typeData)
                {
                    if ([[dict objectForKey:@"name"] isEqualToString:self.title])
                    {
                        typeDictionary = dict;
                        
                        
                        for (NSString *fields in [dict objectForKey:@"fields"])
                        {
                            if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                            {
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                formatter.dateStyle = NSDateFormatterLongStyle;
                                formatter.timeStyle = NSDateFormatterNoStyle;
                                
                                
                                NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                                [refDataDictionary setObject:stringFromDate forKey:fields];
                            }
                            else
                                [refDataDictionary setObject:@"" forKey:fields];
                            
                        }
                    }
                }
                
                [self.tableView reloadData];
                break;
            case 2:
                self.title = [self.title stringByAppendingString:@" No Author"];
                
                refDataDictionary  = [[NSMutableDictionary alloc] init];
                for (NSDictionary *dict in typeData)
                {
                    if ([[dict objectForKey:@"name"] isEqualToString:self.title])
                    {
                        typeDictionary = dict;
                        
                        
                        for (NSString *fields in [dict objectForKey:@"fields"])
                        {
                            if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"])
                            {
                                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                formatter.dateStyle = NSDateFormatterLongStyle;
                                formatter.timeStyle = NSDateFormatterNoStyle;
                                
                                NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                                [refDataDictionary setObject:stringFromDate forKey:fields];
                            }
                            else
                                [refDataDictionary setObject:@"" forKey:fields];
                            
                        }
                    }
                }
                
                [self.tableView reloadData];
                
                break;
            default:
                break;
        }

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IndexViewController sharedIndexVC] hideTopMenu];
    self.navigationController.navigationBar.barTintColor = [self.view.tintColor colorWithAlphaComponent:0.7];
    self.navigationController.navigationBar.backgroundColor = [self.view.tintColor colorWithAlphaComponent:0.5];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"])
    {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"])
    {
        if (section == 0)
           return  [authorArray count];

        return [[typeDictionary objectForKey:@"fields"] count] - 1;
    }
    
    if([[typeDictionary objectForKey:@"name"] isEqualToString:@"Website"])
    {//additional textfield for Website type
        return [[typeDictionary objectForKey:@"fields"] count] + 1;
    }

    return [[typeDictionary objectForKey:@"fields"] count];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"])
    {
        if (indexPath.section == 0)
        {
            DoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doubleCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.firstTextField.placeholder = [NSString stringWithFormat:@"Surname"];
            cell.firstTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Surname"];
            cell.secondTextField.placeholder = [NSString stringWithFormat:@"Initial(s)"];
            cell.secondTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Initials"];

            
            if (singleAuthor == TRUE)
                [cell.addRemoveButton setHidden:TRUE];
            
            [cell.addRemoveButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            [cell.addRemoveButton setFrame:CGRectMake(283, 14, 22, 22)];

            if (indexPath.row != 0)
            {
                
                cell.firstTextField.placeholder = [NSString stringWithFormat:@"Surname %i",indexPath.row + 1];
                cell.firstTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Surname"];
                cell.secondTextField.placeholder = [NSString stringWithFormat:@"Initial(s) %i",indexPath.row + 1];
                cell.secondTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Initials"];

                [cell.addRemoveButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
                [cell.addRemoveButton setFrame:CGRectMake(283, 14, 22, 22)];
            }
            
            return cell;

        }
        else
        {
            FullWidthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fullWidthCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.textField.placeholder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row + 1]];
            
            
            cell.textField.keyboardType = UIKeyboardTypeDefault;
 
            if ([cell.textField.placeholder isEqualToString:@"Year"])
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            if ([cell.textField.placeholder isEqualToString:@"URL"] || [cell.textField.placeholder isEqualToString:@"Image URL"] || [cell.textField.placeholder isEqualToString:@"Video URL"] || [cell.textField.placeholder isEqualToString:@"Website"])
                cell.textField.keyboardType = UIKeyboardTypeURL;

            
            cell.textField.text = [NSString stringWithFormat:@"%@",[refDataDictionary objectForKey:[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row + 1]]];
            return cell;
        }
    }
    else
    {
        NSString *typeName = [typeDictionary objectForKey:@"name"];
        
        if([typeName isEqualToString:@"Website"]) {

            if(indexPath.row == 0){

                SearchBarTableViewCell *result = [tableView dequeueReusableCellWithIdentifier:@"SearchBarTableViewCell" forIndexPath:indexPath];
                result.delegate = self;

                NSString *strVal = [refDataDictionary objectForKey:[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row]];
                if(strVal == nil) {
                    result.searchField.text = @"";
                }
                else{
                    result.searchField.text = strVal;
                }

                //result.searchField.text = @"https://www.macworld.com/article/3137575/macs/the-new-macbook-pro-isnt-just-a-laptop-its-a-strategy-shift.html";

                //result.searchField.text = @"https://www.macrumors.com/roundup/ipad/";

                return result;

            }
            else
            {
                FullWidthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fullWidthCell" forIndexPath:indexPath];
                cell.delegate = self;
                cell.textField.placeholder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row-1]];
                
                cell.textField.keyboardType = UIKeyboardTypeDefault;
                
                
                if ([cell.textField.placeholder isEqualToString:@"Year"])
                    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                if ([cell.textField.placeholder isEqualToString:@"URL"] || [cell.textField.placeholder isEqualToString:@"Image URL"] || [cell.textField.placeholder isEqualToString:@"Video URL"] || [cell.textField.placeholder isEqualToString:@"Website"])
                    cell.textField.keyboardType = UIKeyboardTypeURL;
                
                
                cell.textField.text = [NSString stringWithFormat:@"%@",[refDataDictionary objectForKey:[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row-1]]];
                return cell;
            }
            
        }
        else{
            FullWidthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fullWidthCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.textField.placeholder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row]];
            
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            
            
            if ([cell.textField.placeholder isEqualToString:@"Year"])
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            if ([cell.textField.placeholder isEqualToString:@"URL"] || [cell.textField.placeholder isEqualToString:@"Image URL"] || [cell.textField.placeholder isEqualToString:@"Video URL"] || [cell.textField.placeholder isEqualToString:@"Website"])
                cell.textField.keyboardType = UIKeyboardTypeURL;
            
            
            cell.textField.text = [NSString stringWithFormat:@"%@",[refDataDictionary objectForKey:[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row]]];
            return cell;
        }
    }
}

-(void)addButtonPressedAtCell:(DoubleTableViewCell *)cell
{
    
    [self.view endEditing:TRUE];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.row == 0)
    {
        [authorArray addObject:[@{@"Surname":@"",@"Initials":@""} mutableCopy]];

        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[authorArray count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [authorArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3f];

    }
    
    
}


-(void)projectSelectorDidSelectProject:(Project *)project {
  _currentProject = project;
  [self saveButtonPressed:nil];
}

//- (IBAction)btn_ChooseYourCitationStyle:(id)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Helper" bundle:nil];
//    Picker_VC *pickerVC = [storyboard instantiateViewControllerWithIdentifier:@"Picker_VC"];
//
//    [self addChildViewController:pickerVC];
//    [self.view addSubview:pickerVC.view];
//}

-(void)picker_Recieve :(NSNotification *) notification {
    _txt_ChooseYourCitationStyle.text = [NSString stringWithFormat:@"%@", notification.object];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    [self.view endEditing:TRUE];
    
    if (_currentProject == nil) {
      ProjectSelectorViewController *selector = [self.storyboard instantiateViewControllerWithIdentifier:@"projectSelectorVC"];
      selector.delegate = self;
      [self presentViewController:selector animated:true completion:nil];
      return;
    }
    
    if (_currentReference != nil)
    {
        
        
        if ([self hasEmptyCells])
            return;

        if ([_currentProject.onlineProject boolValue] == TRUE)
        {
         
            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view.window addSubview:loadingView];
            [loadingView fadeIn];

            NSError *error;
            
            if ([refDataDictionary objectForKey:@"Author Double Field"] != nil)
                [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
            {
                NSMutableDictionary *refData = [NSJSONSerialization JSONObjectWithData:[_currentReference.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                [refDataDictionary setObject:[refData objectForKey:@"hasEditors"]  forKey:@"hasEditors"];
                
            }
            
            
            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];

            [[ReferencingApp sharedInstance] editReferenceWithData:dataString referenceType:_currentReference.referenceType projectID:_currentReference.projectID andReferenceID:_currentReference.referenceID];
            

        }
        else
        {
            NSError *error;
            if ([refDataDictionary objectForKey:@"Author Double Field"] != nil)
                [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
            {
                NSMutableDictionary *refData = [NSJSONSerialization JSONObjectWithData:[_currentReference.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                [refDataDictionary setObject:[refData objectForKey:@"hasEditors"]  forKey:@"hasEditors"];

            }

            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            _currentReference.data = dataString;
            
            [[ReferencingApp sharedInstance] saveDatabase];
            
        
            [[IndexViewController sharedIndexVC] saveSucessfull];
            [self.navigationController popViewControllerAnimated:true];

        }
    }
    else
    {
        
        if ([self hasEmptyCells])
            return;
        
        
        
        
        if ([_currentProject.onlineProject boolValue] == TRUE)
        {
            NSError *error;
            [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
                [refDataDictionary setObject:[NSNumber numberWithBool:hasEditors] forKey:@"hasEditors"];

            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            
            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view.window addSubview:loadingView];
            [loadingView fadeIn];
            
            [[ReferencingApp sharedInstance] createReferenceWithData:dataString referenceType:[typeDictionary objectForKey:@"name"] andProjectID:_currentProject.projectID];
            

        }
        else
        {
            
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
            Reference *newRef = [NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:managedObjectContext];
            
            NSError *error;
            [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
                [refDataDictionary setObject:[NSNumber numberWithBool:hasEditors] forKey:@"hasEditors"];

            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            
            newRef.dateCreated = [NSDate date];
            newRef.data = dataString;
            newRef.referenceType = [typeDictionary objectForKey:@"name"];
            
            _currentReference = newRef;
            
            [_currentProject addReferencesObject:newRef];
            
            [[ReferencingApp sharedInstance] saveDatabase];
            
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for (UIViewController *aViewController in allViewControllers) {
                if ([aViewController isKindOfClass:[ProjectReferencesTableViewController class]]) {
                    [[IndexViewController sharedIndexVC] saveSucessfull];
                    [self.navigationController popToViewController:aViewController animated:TRUE];
                    return;

                }
            }
            
            
            [[IndexViewController sharedIndexVC] saveSucessfull];
            [self.navigationController popViewControllerAnimated:true];
            

        }
        
    }
    
}


-(BOOL)hasEmptyCells
{
    
    for (NSString *key in refDataDictionary )
    {
        NSString *checkForEmptyString = [refDataDictionary objectForKey:key];
        
        if ([key isEqualToString:@"Author Double Field"])
        {
            for (NSMutableDictionary *authorDict in authorArray)
            {
                for (NSString *authorString in [authorDict allValues])
                {
                    if ([authorString isEqualToString:@""])
                    {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                                       message: @"Please fill the fields."
                                                                      delegate: self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                        [alert show];
                        return TRUE;
                    }
                }
            }
        }
        else if ([checkForEmptyString isEqualToString:@""] &&  ![key isEqualToString:@"Edition"]  && ![key isEqualToString:@"Issue"] && ![key isEqualToString:@"Web URL"])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Please fill the fields."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
            return TRUE;
        }
    }

    return FALSE;
}

-(void)editingEndedAtCell:(FullWidthTableViewCell *)cell
{
    [refDataDictionary setObject:cell.textField.text forKey:cell.textField.placeholder];
    
}

-(void)surnameEndEditingAtCell:(DoubleTableViewCell *)cell
{
    NSLog(@"%@",authorArray);

    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [[authorArray objectAtIndex:indexPath.row] setObject:cell.firstTextField.text forKey:@"Surname"];
    
    NSLog(@"%@",authorArray);

}

-(void)initialsEndEditingAtCell:(DoubleTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [[authorArray objectAtIndex:indexPath.row] setObject:cell.secondTextField.text forKey:@"Initials"];
    
    NSLog(@"%@",authorArray);

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

#pragma mark REFERECING APP DELEGATE

-(void)referenceEditingFailedWithErrror:(NSString *)errorString
{
    [self.tableView reloadData];
    
    [self unloadLoadingView];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
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


-(void)referenceSucessfullyEdited:(NSDictionary *)dictionary
{
 
    _currentReference.data = [dictionary objectForKey:@"data"];
    
    [self unloadLoadingView];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ProjectReferencesTableViewController class]]) {
            [[IndexViewController sharedIndexVC] saveSucessfull];
            
            [self.navigationController popToViewController:aViewController animated:TRUE];
            return;

        }
    }
    
    
    
    [[IndexViewController sharedIndexVC] saveSucessfull];
    
    [self.navigationController popViewControllerAnimated:true];

    

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

    _currentReference = newRef;

    [_currentProject addReferencesObject:newRef];
    
    [self unloadLoadingView];

    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ProjectReferencesTableViewController class]]) {
            [[IndexViewController sharedIndexVC] saveSucessfull];
              
            [self.navigationController popToViewController:aViewController animated:TRUE];
            return;

        }
    }
    

    
    [[IndexViewController sharedIndexVC] saveSucessfull];

    [self.navigationController popViewControllerAnimated:true];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text capitalizedString];
    return true;
}

#pragma - SearchBarTableViewCellDelegate

-(void)didEndEditingSearchBarCell:(SearchBarTableViewCell *)cell strValue:(NSString *) strValue {
    
    if(strValue != nil && strValue.length > 0) {
        
        NSString *tempStrURL = [strValue lowercaseString];
        
        if(![tempStrURL hasPrefix:@"http://"]){
            if(![tempStrURL hasPrefix:@"https://"]){
                tempStrURL = [NSString stringWithFormat:@"http://%@", tempStrURL];
            }
        }
        
        if([Utilities validateUrl:tempStrURL]) {
            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view.window addSubview:loadingView];
            [loadingView fadeIn];
            
            WebDataManager *wdm = [[WebDataManager alloc] init];
            wdm.delegate = self;
            [wdm extractDataFromURL:tempStrURL];
        }
        else{

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Please enter valid web url."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                       message: @"Please enter web url."
                                                      delegate: self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
}

- (NSString *) removeToken:(NSString *) strToken from:(NSString *) strString
{
    strString = [strString substringFromIndex:strToken.length];
    
    if([strString containsString:@"."]){
        NSRange range = [strString rangeOfString:@"."];
        if(range.location != NSNotFound){
            strString = [strString substringToIndex:range.location];
        }
    }
    
    return strString;
}

- (NSString *) validateAuthor:(NSString *) strAuthor strURL:(NSString *) strURL
{
    if(strAuthor == nil || strAuthor.length == 0){
        NSURL *url = [NSURL URLWithString:strURL];
        strAuthor = [url host];
        
        if([strAuthor hasPrefix:@"www."]){
            strAuthor = [self removeToken:@"www." from:strAuthor];
        }
        else if([strAuthor hasPrefix:@"http://www."]){
            strAuthor = [self removeToken:@"http://www." from:strAuthor];
        }
        else if([strAuthor hasPrefix:@"https://www."]){
            strAuthor = [self removeToken:@"https://www." from:strAuthor];
        }
        else if([strAuthor hasPrefix:@"http://"]){
            strAuthor = [self removeToken:@"http://" from:strAuthor];
        }
        else if([strAuthor hasPrefix:@"https://"]){
            strAuthor = [self removeToken:@"https://" from:strAuthor];
        }
        
        
        strAuthor = [NSString stringWithFormat:@"%@%@",[[strAuthor substringToIndex:1] uppercaseString],[strAuthor substringFromIndex:1] ];
    }
    
    return strAuthor;
}

#pragma mark - WebDataManagerDelegate

-(void)didExtractedDataFromURL:(WebDataManager *)dataManager dictionary:(NSDictionary *) responseDictionary
{

    if(responseDictionary != nil) {
        
        NSDictionary *webData = responseDictionary;
        NSString *strTitle = [webData objectForKey:@"title"];
        NSString *strURL = [webData objectForKey:@"url"];
        NSString *strAuthor = [webData objectForKey:@"author"];
        NSString *strDate = [webData objectForKey:@"date"];
        
        strAuthor = [self validateAuthor:strAuthor strURL:strURL];
        
        NSString *lastAccessed = [Utilities dateToString:[NSDate date] format:@"dd MMMM YYYY"];
        NSArray* fields = [typeDictionary objectForKey:@"fields"];
        for(int i = 0; i < fields.count; ++i){
            NSString *strKey = [fields objectAtIndex:i];
            if([strKey isEqualToString:@"Title"]) {
                [refDataDictionary setObject:strTitle forKey:strKey];
            }
            else if([strKey isEqualToString:@"URL"]){
                [refDataDictionary setObject:strURL forKey:strKey];
            }
            else if([strKey isEqualToString:@"Last Accessed"]){
                [refDataDictionary setObject:lastAccessed forKey:strKey];
            }
            else if([strKey isEqualToString:@"Year"]){
                if(strDate != nil) {
                    [refDataDictionary setObject:strDate forKey:strKey];
                }
            }
            else if([strKey isEqualToString:@"Name of Website/Author"]){
                if(strAuthor != nil) {
                    [refDataDictionary setObject:strAuthor forKey:strKey];
                }
            }
            
        }
        
        [refDataDictionary setObject:strURL forKey:@"Web URL"];
        
        [self.tableView reloadData];
        [self unloadLoadingView];
    }
    else{
        [self unloadLoadingView];
    }
}


@end

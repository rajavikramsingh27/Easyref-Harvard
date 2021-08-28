//
//  CreateReference_ViewController.m
//  Harvard
//
//  Created by appentus technologies pvt. ltd. on 10/14/19.
//  Copyright © 2019 SquaredDimesions. All rights reserved.



#import "CreateReference_ViewController.h"

#import "SegmentTableViewCell.h"
#import "AppDelegate.h"
#import "ProjectReferencesTableViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

#import "WebDataManager.h"
#import "Utilities.h"
#import "Picker_VC.h"
#import "Date_Picker_ViewController.h"
//#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>


@import MobileCoreServices;    // only needed in iOS


@interface CreateReference_ViewController () <WebDataManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation CreateReference_ViewController

- (void)viewDidDisappear:(BOOL)animated {
//    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.arr_Style_Picker = [[NSMutableArray alloc]init];
//    [self func_get_styles];
    
    UIPickerView *objPickerView = [UIPickerView new];
    
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(func_Done_PickerView)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.txt_ChooseYourCitationStyle setInputAccessoryView:toolBar];
    
    self.txt_ChooseYourCitationStyle.inputView = objPickerView;
    
    typeDictionary = [[NSMutableDictionary alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tbl_creat_reference.delegate = self;
    self.tbl_creat_reference.dataSource = self;
    
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
    } else {
        singleAuthor = FALSE;
    }
    
    hasEditors = FALSE;
    
    typeData = [ReferencingApp sharedInstance].typeData;
    
    refDataDictionary  = [[NSMutableDictionary alloc] init];
    
    if (_currentReference == nil) {
        authorArray = [[NSMutableArray alloc] initWithObjects:[@{@"Surname":@"",@"Initials":@""} mutableCopy], nil];
//        authorArray = [[NSMutableArray alloc] initWithObjects:[@{@"Firstname":@"",@"Lastname":@""} mutableCopy], nil];
        
        for (NSDictionary *dict in typeData)
        {
            if ([[dict objectForKey:@"name"] isEqualToString:self.title])
            {
                NSArray *arr_Fields = @[@"Author Double Field",@"DATE PUBLISHED",@"TITLE OF POST",@"BLOG TITLE",@"URL",@"DATE ACCESSED/VIEWED"];
                typeDictionary = dict;
//                if ([[dict objectForKey:@"name"] isEqualToString:@"Blog"]) {
//                    NSDictionary *ddict = @{@"fields":arr_Fields,@"name":@"Blog"};
//                    typeDictionary = ddict;
//                }
                
                for (NSString *fields in [typeDictionary objectForKey:@"fields"])
                {
                    if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"]) {
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateStyle = NSDateFormatterLongStyle;
                        formatter.timeStyle = NSDateFormatterNoStyle;
                        
                        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
                        [refDataDictionary setObject:stringFromDate forKey:fields];
                    }
                    else
                        [refDataDictionary setObject:@"" forKey:fields];
                }
                
//                for (NSString *fields in [dict objectForKey:@"fields"])
//                {
//                    if ([fields isEqualToString:@"Accessed Date"] || [fields isEqualToString:@"Last Accessed"]) {
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                        formatter.dateStyle = NSDateFormatterLongStyle;
//                        formatter.timeStyle = NSDateFormatterNoStyle;
//
//                        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
//                        [refDataDictionary setObject:stringFromDate forKey:fields];
//                    }
//                    else
//                        [refDataDictionary setObject:@"" forKey:fields];
//                }
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

-(void)func_Done_PickerView {
    [self.txt_ChooseYourCitationStyle resignFirstResponder];
    self.txt_ChooseYourCitationStyle.text = @"";
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



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[IndexViewController sharedIndexVC] hideTopMenu];
    self.navigationController.navigationBar.barTintColor = [self.view.tintColor colorWithAlphaComponent:0.7];
    self.navigationController.navigationBar.backgroundColor = [self.view.tintColor colorWithAlphaComponent:0.5];
    
//    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"])  {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"]) {
        if (section == 0)
            return  [authorArray count];
        return [[typeDictionary objectForKey:@"fields"] count] - 1;
    }
    
    if([[typeDictionary objectForKey:@"name"] isEqualToString:@"Website"]) {//additional textfield for Website type
        return [[typeDictionary objectForKey:@"fields"] count] + 1;
    }
    
    
    return [[typeDictionary objectForKey:@"fields"] count];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[typeDictionary objectForKey:@"fields"] objectAtIndex:0] isEqualToString:@"Author Double Field"]) {
        if (indexPath.section == 0) {
            DoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doubleCell" forIndexPath:indexPath];
            cell.delegate = self;
//            cell.firstTextField.placeholder = [NSString stringWithFormat:@"Firstname"];
//            cell.firstTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Firstname"];
//            cell.secondTextField.placeholder = [NSString stringWithFormat:@"Lastname"];
//            cell.secondTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Lastname"];
            
            cell.firstTextField.placeholder = [NSString stringWithFormat:@"Surname"];
            cell.firstTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Surname"];
            cell.secondTextField.placeholder = [NSString stringWithFormat:@"Initial(s)"];
            cell.secondTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Initials"];
            
            if (singleAuthor == TRUE)
                [cell.addRemoveButton setHidden:TRUE];
            
            [cell.addRemoveButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
            [cell.addRemoveButton setFrame:CGRectMake(283, 14, 22, 22)];
            
            if (indexPath.row != 0) {
                cell.firstTextField.placeholder = [NSString stringWithFormat:@"Surname %i",indexPath.row + 1];
                cell.firstTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Surname"];
                cell.secondTextField.placeholder = [NSString stringWithFormat:@"Initial(s) %i",indexPath.row + 1];
                cell.secondTextField.text = [[authorArray objectAtIndex:indexPath.row] objectForKey:@"Initial(s)"];
                
                [cell.addRemoveButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
                [cell.addRemoveButton setFrame:CGRectMake(283, 14, 22, 22)];
            }
            return cell;
        } else {
            FullWidthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fullWidthCell" forIndexPath:indexPath];
//            cell.delegate = self;
            cell.textField.placeholder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row + 1]];
            
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            
            if ([cell.textField.placeholder isEqualToString:@"Year"])
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            if ([cell.textField.placeholder isEqualToString:@"URL"] || [cell.textField.placeholder isEqualToString:@"Image URL"] || [cell.textField.placeholder isEqualToString:@"Video URL"] || [cell.textField.placeholder isEqualToString:@"Website"])
                cell.textField.keyboardType = UIKeyboardTypeURL;
            
            NSString *str_Fields = [NSString stringWithFormat:@"%@",[refDataDictionary objectForKey:[[typeDictionary objectForKey:@"fields"] objectAtIndex:indexPath.row + 1]]];
            NSLog(@"%@",str_Fields);
            
            if ([str_Fields isEqual:@"(null)"]) {
                cell.textField.text = @"";
            } else {
                cell.textField.text = str_Fields;
            }
            
            cell.textField.tag = indexPath.row + 1;
            cell.textField.delegate = self;
            
//            [cell.textField removeTarget:self action:@selector(func_TextField:) forControlEvents:UIControlEventEditingDidBegin];
//            [cell.textField addTarget:self action:@selector(func_TextField:) forControlEvents:UIControlEventEditingDidBegin];
            
            return cell;
        }
    }
    else
    {
        NSString *typeName = [typeDictionary objectForKey:@"name"];
        
        if([typeName isEqualToString:@"Website"]) {
            
            if(indexPath.row == 0) {
                
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



- (IBAction)btn_ChooseYourCitationStyle:(id)sender {
    UIPickerView *objPickerView = [UIPickerView new];
    
    objPickerView.delegate = self;
    objPickerView.dataSource = self;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btn_done_ToolBar)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    
    [self.txt_ChooseYourCitationStyle setInputAccessoryView:toolBar];
}

-(void)picker_Recieve :(NSNotification *) notification {
    _txt_ChooseYourCitationStyle.text = [NSString stringWithFormat:@"%@", notification.object];
}

-(void) func_save_API {
//        NSArray *arr_AutherField = [refDataDictionary objectForKey:@"Author Double Field"];
//        NSString *str_firstName = [[arr_AutherField objectAtIndex:0] objectForKey:@"Firstname"];
//        NSString *str_lastname = [[arr_AutherField objectAtIndex:0] objectForKey:@"Lastname"];
//
//        NSString *str_BLOG_TITLE = [refDataDictionary objectForKey:@"BLOG TITLE"];
//        NSString *str_DATE_ACCESSED_VIEWED = [refDataDictionary objectForKey:@"DATE ACCESSED/VIEWED"];
//        NSString *str_DATE_PUBLISHED = [refDataDictionary objectForKey:@"DATE PUBLISHED"];
//        NSString *str_TITLE_OF_POST = [refDataDictionary objectForKey:@"TITLE OF POST"];
//        NSString *str_URL = [refDataDictionary objectForKey:@"URL"];
    
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
        [self func_POST_API:jsonString];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self.view endEditing:TRUE];
    
//    if (_currentProject == nil) {
//        ProjectSelectorViewController *selector = [self.storyboard instantiateViewControllerWithIdentifier:@"projectSelectorVC"];
//        selector.delegate = self;
//        [self presentViewController:selector animated:true completion:nil];
//        return;
//    }
//
//    if (_currentReference != nil)
//    {
//        if ([self hasEmptyCells])
//            return;
//
//        if ([_currentProject.onlineProject boolValue] == TRUE)
//        {
//            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
//            [self.view.window addSubview:loadingView];
//            [loadingView fadeIn];
//
//            NSError *error;
//
//            if ([refDataDictionary objectForKey:@"Author Double Field"] != nil)
//                [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
//            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
//            {
//                NSMutableDictionary *refData = [NSJSONSerialization JSONObjectWithData:[_currentReference.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//                [refDataDictionary setObject:[refData objectForKey:@"hasEditors"]  forKey:@"hasEditors"];
//
//            }
//
//
//            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
//
//            [[ReferencingApp sharedInstance] editReferenceWithData:dataString referenceType:_currentReference.referenceType projectID:_currentReference.projectID andReferenceID:_currentReference.referenceID];
//
//
//        }
//        else
//        {
//            NSError *error;
//            if ([refDataDictionary objectForKey:@"Author Double Field"] != nil)
//                [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
//            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
//            {
//                NSMutableDictionary *refData = [NSJSONSerialization JSONObjectWithData:[_currentReference.data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//                [refDataDictionary setObject:[refData objectForKey:@"hasEditors"]  forKey:@"hasEditors"];
//            }
//
//            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
//            _currentReference.data = dataString;
//
//            [[ReferencingApp sharedInstance] saveDatabase];
//
////            [[IndexViewController sharedIndexVC] saveSucessfull];
//
//            /*********
//             *********
//             *********
//             *********
//             *********
//             *********/
////            [self.navigationController popViewControllerAnimated:true];
//
//        }
//    }
//    else
//    {
//        if ([self hasEmptyCells])
//            return;
//
//        if ([_currentProject.onlineProject boolValue] == TRUE)
//        {
//            NSError *error;
//            [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
//            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
//                [refDataDictionary setObject:[NSNumber numberWithBool:hasEditors] forKey:@"hasEditors"];
//
//            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
//
//            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
//            [self.view.window addSubview:loadingView];
//            [loadingView fadeIn];
//
//            [[ReferencingApp sharedInstance] createReferenceWithData:dataString referenceType:[typeDictionary objectForKey:@"name"] andProjectID:_currentProject.projectID];
//
//
//        } else {
//            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
//            Reference *newRef = [NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:managedObjectContext];
//
//            NSError *error;
//            [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
//            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
//                [refDataDictionary setObject:[NSNumber numberWithBool:hasEditors] forKey:@"hasEditors"];
//
//            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
//
//            newRef.dateCreated = [NSDate date];
//            newRef.data = dataString;
//            newRef.referenceType = [typeDictionary objectForKey:@"name"];
//
//            _currentReference = newRef;
//
//            [_currentProject addReferencesObject:newRef];
//
//            [[ReferencingApp sharedInstance] saveDatabase];
//
//            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//            for (UIViewController *aViewController in allViewControllers) {
//                if ([aViewController isKindOfClass:[ProjectReferencesTableViewController class]]) {
////                    [[IndexViewController sharedIndexVC] saveSucessfull];
////                    [self.navigationController popToViewController:aViewController animated:TRUE];
////                    return;
//                    break;
//                }
//            }
//
//
////            [[IndexViewController sharedIndexVC] saveSucessfull];
//            /*********
//             *********
//             *********
//             *********
//             *********
//             *********/
////            [self.navigationController popViewControllerAnimated:true];
//        }
//
//    }
    [self func_save_API];
}

-(void)func_Back {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[IndexViewController sharedIndexVC] saveSucessfull];
            [self.navigationController popViewControllerAnimated:YES];
        });
}

-(void) func_Save_Local_DB:(NSString*)result_API {
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
            [refDataDictionary setObject:result_API  forKey:@"result_API"];
            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            
            [[ReferencingApp sharedInstance] editReferenceWithData:dataString referenceType:_currentReference.referenceType projectID:_currentReference.projectID andReferenceID:_currentReference.referenceID];
            [self func_Back];
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
            [refDataDictionary setObject:result_API  forKey:@"result_API"];
            
            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            
            _currentReference.data = dataString;
            
            [[ReferencingApp sharedInstance] saveDatabase];
            
            [self func_Back];
            //            [[IndexViewController sharedIndexVC] saveSucessfull];
            
            /*********
             *********
             *********
             *********
             *********
             *********/
            //            [self.navigationController popViewControllerAnimated:true];
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
            [refDataDictionary setObject:result_API  forKey:@"result_API"];
            NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:refDataDictionary options:kNilOptions error:&error] encoding:NSUTF8StringEncoding];
            
            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view.window addSubview:loadingView];
            [loadingView fadeIn];
            
            [[ReferencingApp sharedInstance] createReferenceWithData:dataString referenceType:[typeDictionary objectForKey:@"name"] andProjectID:_currentProject.projectID];
            [self func_Back];
        } else {
            AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
            Reference *newRef = [NSEntityDescription insertNewObjectForEntityForName:@"Reference" inManagedObjectContext:managedObjectContext];
            
            NSError *error;
            [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
            if ([self.title isEqualToString:@"Journal"] || [self.title isEqualToString:@"Book"]|| [self.title isEqualToString:@"Encyclopedia"])
                [refDataDictionary setObject:[NSNumber numberWithBool:hasEditors] forKey:@"hasEditors"];
            [refDataDictionary setObject:result_API  forKey:@"result_API"];
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
                    //                    [[IndexViewController sharedIndexVC] saveSucessfull];
                    //                    [self.navigationController popToViewController:aViewController animated:TRUE];
                    //                    return;
                    break;
                }
            }
            
            [self func_Back];
            //            [[IndexViewController sharedIndexVC] saveSucessfull];
            /*********
             *********
             *********
             *********
             *********
             *********/
            //            [self.navigationController popViewControllerAnimated:true];
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

-(void)editingEndedAtCell:(FullWidthTableViewCell *)cell {
    [refDataDictionary setObject:cell.textField.text forKey:cell.textField.placeholder];
}

-(void)surnameEndEditingAtCell:(DoubleTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [[authorArray objectAtIndex:indexPath.row] setObject:cell.firstTextField.text forKey:@"Firstname"];
    [[authorArray objectAtIndex:indexPath.row] setObject:cell.firstTextField.text forKey:@"Surname"];
    
    NSLog(@"%@",authorArray);
    [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
}

-(void)initialsEndEditingAtCell:(DoubleTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    [[authorArray objectAtIndex:indexPath.row] setObject:cell.secondTextField.text forKey:@"Lastname"];
    [[authorArray objectAtIndex:indexPath.row] setObject:cell.secondTextField.text forKey:@"Initials"];
    
    NSLog(@"%@",authorArray);
    [refDataDictionary setObject:authorArray forKey:@"Author Double Field"];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *str_PlaceHolder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:textField.tag]];
    NSLog(@"%@",str_PlaceHolder);
    
//    if ([str_PlaceHolder isEqualToString:@"DATE PUBLISHED"]) {
    if ([str_PlaceHolder isEqualToString:@"Date of Post"]) {
        
//    } else if ([str_PlaceHolder isEqualToString:@"DATE ACCESSED/VIEWED"]) {
        } else if ([str_PlaceHolder isEqualToString:@"Accessed Date"]) {
        
    } else {
        [refDataDictionary setObject:textField.text forKey:textField.placeholder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
        NSString *str_PlaceHolder = [NSString stringWithFormat:@"%@",[[typeDictionary objectForKey:@"fields"] objectAtIndex:textField.tag]];
        NSLog(@"%@",str_PlaceHolder);
    
//        if ([str_PlaceHolder isEqualToString:@"DATE PUBLISHED"]) {
        if ([str_PlaceHolder isEqualToString:@"Date of Post"]) {
            UIDatePicker *date_picker ;
            date_picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            [date_picker setDatePickerMode:UIDatePickerModeDate];
            [date_picker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            date_picker.tag = 0;
            textField.inputView = date_picker;
            
            UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            [toolBar setTintColor:[UIColor grayColor]];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btn_done_ToolBar)];
            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
            
            [textField setInputAccessoryView:toolBar];
//        } else if ([str_PlaceHolder isEqualToString:@"DATE ACCESSED/VIEWED"]) {
//        } else if ([str_PlaceHolder isEqualToString:@"Accessed Date"]) {
        } else if ([str_PlaceHolder isEqualToString:@"Accessed Date"]) {
            UIDatePicker *date_picker;
            date_picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
            [date_picker setDatePickerMode:UIDatePickerModeDate];
            [date_picker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            date_picker.tag = 1;
            textField.inputView = date_picker;
            
            UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            [toolBar setTintColor:[UIColor grayColor]];
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(btn_done_ToolBar)];
            UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
            
            [textField setInputAccessoryView:toolBar];
        }
    }

-(void)btn_done_ToolBar {
    [_tableView reloadData];
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker {
    NSDateFormatter * formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy,MM,dd"];
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    
    NSLog(@"date selected %@",dateString);
    if (datePicker.tag == 0) {
//        [refDataDictionary setObject:dateString forKey:@"DATE PUBLISHED"];
        [refDataDictionary setObject:dateString forKey:@"Date of Post"];
    } else if (datePicker.tag == 1) {
//        [refDataDictionary setObject:dateString forKey:@"DATE ACCESSED/VIEWED"];
        [refDataDictionary setObject:dateString forKey:@"Accessed Date"];
    }
    
    NSLog(@"%@",refDataDictionary);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Please enter valid web url."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];
        }
    } else {
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
    self.txt_ChooseYourCitationStyle.text = self.arr_Style_Picker[row];
}



-(void) func_get_styles {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString *full_URL = [NSString stringWithFormat:@"http://3.19.62.211:5000/get_styles"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:full_URL]];
    
    //    NSString *userUpdate =[NSString stringWithFormat:@"user=%@&password=%@&api_id=%@&to=%@&text=%@",_username,_password,_apiID,[_numbers componentsJoinedByString:@","],_txtMsg.text, nil];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    //    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    //    [urlRequest setHTTPBody:data1];
    
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
                    strStyle_Filter = [[strStyle stringByReplacingOccurrencesOfString:@"/home/ubuntu/.local/lib/python2.7/site-packages/citeproc/data/styles/dependent/" withString:@""] mutableCopy];
                    strStyle_Filter = [[strStyle_Filter stringByReplacingOccurrencesOfString:@".csl" withString:@""] mutableCopy];
                    [self.arr_Style_Picker addObject:strStyle_Filter];
                }
            }
        }
    }];
    [dataTask resume];
}



-(void)func_get: (NSString*)json {
    //    NSString *str_Param = [NSString stringWithFormat:@"json:%@&style_name:%@",json,self.txt_ChooseYourCitationStyle.text];
    //    NSString *param = [NSString stringWithFormat:@"json=%@&style_name=%@",json,self.txt_ChooseYourCitationStyle.text];
    //    NSLog(@"str_Param \n%@",param);
    //    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://3.19.62.211:5000/get"]];
    
    NSString *userUpdate =[NSString stringWithFormat:@"json=json&style_name=future-virology"];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            if(success == 1)
            {
                NSLog(@"Login SUCCESS");
            }
            else
            {
                NSLog(@"Login FAILURE");
            }
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    
    return;
    
    
//
//
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
//                               @"User-Agent": @"PostmanRuntime/7.17.1",
//                               @"Accept": @"*/*",
//                               @"Cache-Control": @"no-cache",
////                               @"Postman-Token": @"bf5d93a5-0f94-4703-8fd1-dc78e54af53e,a155e00c-df58-4e5d-9af9-2832ca75a698",
//                               @"Host": @"3.19.62.211:5000",
//                               @"Content-Type": @"multipart/form-data; boundary=--------------------------053104914594977153577004",
//                               @"Accept-Encoding": @"gzip, deflate",
////                               @"Content-Length": @"666",
//                               @"Connection": @"keep-alive",
//                               @"cache-control": @"no-cache" };
//
//    NSDictionary *dict_Param = [[NSDictionary alloc] initWithObjectsAndKeys:@"json", @"json",
//                                self.txt_ChooseYourCitationStyle.text, @"style_name",
//                                nil];
//    NSLog(@"dict_Param is- %@",dict_Param);
//    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict_Param options:0 error:nil];
//
//    NSString *full_URL = [NSString stringWithFormat:@"http://3.19.62.211:5000/get"];
////    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:full_URL]];
//        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:full_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:600.0];
//
//    [urlRequest setHTTPBody:postData];
//    [urlRequest setHTTPMethod:@"POST"];
////    [urlRequest setAllHTTPHeaderFields:headers];
////    [urlRequest addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
////    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [urlRequest addValue:@"text/html; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [urlRequest addValue:@"multipart/form-data; boundary=--------------------------053104914594977153577004" forHTTPHeaderField:@"Content-Type"];
//    [urlRequest addValue:@"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW" forHTTPHeaderField:@"Content-Type"];
//
//
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error == nil) {
//            NSLog(@"error is:- %@",error);
//        }
//
//        //        NSLog(@"response is:- %@",response);
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSLog(@"httpResponse is:- %@",httpResponse);
//
//        if(httpResponse.statusCode == 200) {
//            NSError *parseError = nil;
//            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//            NSLog(@"response is:- %@",responseDictionary);
//            NSInteger success = [[responseDictionary objectForKey:@"status"] integerValue];
//
//            if(success == 1) {
//                //                NSArray *arrStyles = [responseDictionary objectForKey:@"styles"];
//
//                //                for (NSString *strStyle in arrStyles) {
//                //                    NSMutableString *strStyle_Filter = [[NSMutableString alloc]init];
//                //                    strStyle_Filter = [[strStyle stringByReplacingOccurrencesOfString:@"/home/ubuntu/.local/lib/python2.7/site-packages/citeproc/data/styles/" withString:@""] mutableCopy];
//                //                    strStyle_Filter = [[strStyle_Filter stringByReplacingOccurrencesOfString:@".csl" withString:@""] mutableCopy];
//                //                    [self.arr_Style_Picker addObject:strStyle_Filter];
//                //                }
//            }
//        }
//    }];
//    [dataTask resume];
}



//- (void) func_get:(NSString*)json {
////    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
////                               @"User-Agent": @"PostmanRuntime/7.17.1",
////                               @"Accept": @"*/*",
////                               @"Cache-Control": @"no-cache",
////                               @"Postman-Token": @"bf5d93a5-0f94-4703-8fd1-dc78e54af53e,a155e00c-df58-4e5d-9af9-2832ca75a698",
////                               @"Host": @"3.19.62.211:5000",
////                               @"Content-Type": @"multipart/form-data; boundary=--------------------------053104914594977153577004",
////                               @"Accept-Encoding": @"gzip, deflate",
////                               @"Content-Length": @"666",
////                               @"Connection": @"keep-alive",
////                               @"cache-control": @"no-cache" };
//
//    NSDictionary *dict_Param = [[NSDictionary alloc] initWithObjectsAndKeys: json, @"json",
//                                self.txt_ChooseYourCitationStyle.text, @"style_name",
//                                nil];
//    NSLog(@"dict_Param is- %@",dict_Param);
//
////    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict_Param options:0 error:nil];
////    NSString *full_URL = [NSString stringWithFormat:@"http://3.19.62.211:5000/get"];
//
//    NSString * strServiceURL = [NSString stringWithFormat:@"http://3.19.62.211:5000/get"];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//
//    [manager POST:strServiceURL parameters:dict_Param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////        if (fileData!=nil){
////            [formData appendPartWithFileData:fileData name:@"Key name on which you will upload file" fileName:@"Image name" mimeType:@"image/jpeg"];
////        }
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
////        block(responseObject,nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
////        block (nil , error);
//    }];
//}



//- (void) func_get:(NSString*)json {
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
//                               @"User-Agent": @"PostmanRuntime/7.17.1",
//                               @"Accept": @"*/*",
//                               @"Cache-Control": @"no-cache",
//                               @"Postman-Token": @"bf5d93a5-0f94-4703-8fd1-dc78e54af53e,a155e00c-df58-4e5d-9af9-2832ca75a698",
//                               @"Host": @"3.19.62.211:5000",
//                               @"Content-Type": @"multipart/form-data; boundary=--------------------------053104914594977153577004",
//                               @"Accept-Encoding": @"gzip, deflate",
//                               @"Content-Length": @"666",
//                               @"Connection": @"keep-alive",
//                               @"cache-control": @"no-cache" };
//
//
//
////    NSArray *parameters = @[ @{ @"name": @"json", @"value": @"[
////                                {
////                                    \"author\" : [
////                                    {
////                                        \"given\" : \"iOS\",
////                                        \"family\" : \"Raja\"
////                                    }
////                                    ],
////                                    \"issued\" : {
////                                    \"date-parts\" : [
////                                    \"2018 10 1\"
////                                    ]
////                                },
////                                \"id\" : \"ITEM-1\",
////                                \"title\" : \"Post\",
////                                \"container-title\" : \"Blog\",
////                                \"type\" : \"post-weblog\",
////                                \"accessed\" : {
////                                \"date-parts\" : [
////                                \"2018 10 1\"
////                                ]
////                                },
////                             \"URL\" : \"Www.App.Com\"
////                             }
////                             ]" },
////    @{ @"name": @"style_name", @"value": @"future-virology" }];
//
//
//
//    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
//
//    NSDictionary *dict_Param = [[NSDictionary alloc] initWithObjectsAndKeys: json, @"json",
//                                self.txt_ChooseYourCitationStyle.text, @"style_name",
//                                nil];
//    NSLog(@"dict_Param is- %@",dict_Param);
//
//    NSError *error;
//    NSMutableString *body = [NSMutableString new];
//    for (NSDictionary *param in dict_Param) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"fileName"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//
//
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://3.19.62.211:5000/get"]
//                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval:10.0];
//    [request setHTTPMethod:@"POST"];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if (error) {
//                                                        NSLog(@"%@", error);
//                                                    } else {
//                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//                                                        NSLog(@"%@", httpResponse);
//                                                    }
//                                                }];
//    [dataTask resume];
//}

-(void) func_POST_API: (NSString*)json {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSDictionary *dict_Param = [[NSDictionary alloc] initWithObjectsAndKeys:
                                json, @"json",
                                self.str_Selected_Style, @"style",
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
//        NSLog(@"response is:- %@",response);
//        if (error) {
//            NSLog(@"error = %@", error);
//            return;
//        }
        
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
                
//                NSLog(@"%@",[self convertHTML:str_MSG]);
                
                [self func_Save_Local_DB:str_MSG];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UILabel *lbl_HTML = [[UILabel alloc]initWithFrame:CGRectMake(0, 100,300, 100)];
                    
//                    lbl_HTML.numberOfLines = 50;
//                    lbl_HTML.backgroundColor = [UIColor redColor];
//                    lbl_HTML.attributedText = [self convertHTML:str_MSG];
//
//                    [self.view addSubview:lbl_HTML];
//                    [self.view bringSubviewToFront:lbl_HTML];
                    
//                    [[IndexViewController sharedIndexVC] saveSucessfull];
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:str_MSG preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *ok_Action = [UIAlertAction actionWithTitle:@"0K" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
//                [alert addAction:ok_Action];
//                [self presentViewController:alert animated:YES completion:nil];
            } else {
                NSString *str_error = [responseDictionary objectForKey:@"error"];
                NSLog(@"str_error is:- %@",str_error);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[IndexViewController sharedIndexVC] error_POPUP:str_error];
                });
            }
        }
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result = %@", result);
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

@end

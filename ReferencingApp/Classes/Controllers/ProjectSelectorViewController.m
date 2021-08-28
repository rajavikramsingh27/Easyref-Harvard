//
//  ProjectSelectorViewController.m
//  EasyRef
//
//  Created by Radu Mihaiu on 18/01/2016.
//  Copyright © 2016 SquaredDimesions. All rights reserved.
//

#import "ProjectSelectorViewController.h"
#import "ProjectTableViewCell.h"
#import "ReferencingApp.h"


@interface ProjectSelectorViewController () {
  NSArray *projectsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ProjectSelectorViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 55.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Local";
  }
  return [ReferencingApp sharedInstance].user.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([ReferencingApp sharedInstance].isOffline == true) {
    return 1;
  }
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return  [projectsArray count];
  }
  return [[ReferencingApp sharedInstance].onlineProjectsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectCell" forIndexPath:indexPath];
  cell.coverView.userInteractionEnabled = false;
  
  if (indexPath.section == 0) {
    Project *project = [projectsArray objectAtIndex:indexPath.row];
    cell.projectTextField.text = project.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[project.references count]];
  }
  else {
    Project *project = [[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row];
    cell.projectTextField.text = project.name;
    cell.numberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[project.references count]];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([_delegate respondsToSelector:@selector(projectSelectorDidSelectProject:)]) {
    if (indexPath.section == 0)
      [_delegate projectSelectorDidSelectProject:[projectsArray objectAtIndex:indexPath.row]];
    else
      [_delegate projectSelectorDidSelectProject:[[ReferencingApp sharedInstance].onlineProjectsArray objectAtIndex:indexPath.row]];
  }
  
  [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)cancelButtonPressed:(id)sender {
  [self dismissViewControllerAnimated:true completion:nil];
}

@end

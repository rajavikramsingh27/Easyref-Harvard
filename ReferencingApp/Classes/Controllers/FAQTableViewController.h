//
//  UncategorizedTableViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *helpfulLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong,nonatomic) NSString *contentString;
@property (strong,nonatomic) NSString *titleString;

@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;
@end

//
//  UncategorizedTableViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 20/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "FAQTableViewController.h"

@interface FAQTableViewController ()

@end

@implementation FAQTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    [self.helpfulLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:12.0f]];
    [self.projectsLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:24.0f]];
    [self.contentLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:12.0f]];


    _contentLabel.text = _contentString;
    _projectsLabel.text = _titleString;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarVisible:false animated:true];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize maximumLabelSize = CGSizeMake(290, CGFLOAT_MAX);
    
    CGRect textRect = [self.contentLabel.text boundingRectWithSize:maximumLabelSize
                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"MuseoSlab-500" size:13.0f]}
                                                        context:nil];
    return  30 + lroundf(textRect.size.height);

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



- (IBAction)yesButtonPressed:(id)sender
{
    _noButton.enabled = FALSE;
    
    
    UILabel *thankyouLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 30)];
    [thankyouLabel setTextColor:[UIColor colorWithWhite:0.4 alpha:1.0f]];

    [thankyouLabel setFrame:CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30)];
    
    [thankyouLabel setTextAlignment:NSTextAlignmentCenter];
    [thankyouLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:15.0f]];
    [thankyouLabel setText:@"Thank you!"];
    
    [self.view addSubview:thankyouLabel];
}


- (IBAction)noButtonPressed:(id)sender
{
    _yesButton.enabled = FALSE;
}
@end

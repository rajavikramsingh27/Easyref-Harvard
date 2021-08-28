//
//  DragViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 27/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "DragViewController.h"
#import "StatsTableViewCell.h"
#import "ReferencingApp.h"
#import "SettingsTableViewController.h"

@interface DragViewController ()

@end

@implementation DragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    animationInProgress = false;
    self.title = @"Easy Referencing";
    initialWidth = self.view.frame.size.width;
    referenceTypeArray = [ReferencingApp sharedInstance].referenceTypeArray;
    
    
    badgeArray = @[
                           @{ @"numberOfRefs":@10 , @"name": @"No Badge" , @"imgValue":[UIImage imageNamed:@"badge1"] },
                           @{ @"numberOfRefs":@20 , @"name": @"Bronze Badge" , @"imgValue":[UIImage imageNamed:@"badge1"] },
                           @{ @"numberOfRefs":@30 , @"name": @"Silver Badge"  , @"imgValue":[UIImage imageNamed:@"badge2"]},
                           @{ @"numberOfRefs":@40 , @"name": @"Gold Badge" , @"imgValue":[UIImage imageNamed:@"badge3"]},
                           @{ @"numberOfRefs":@50 , @"name": @"Platinum Badge" , @"imgValue":[UIImage imageNamed:@"badge4"]},
                           @{ @"numberOfRefs":@60 , @"name": @"Diamond Badge" , @"imgValue":[UIImage imageNamed:@"badge5"]},
                           @{ @"numberOfRefs":@100 , @"name": @"Adamantium Badge" , @"imgValue":[UIImage imageNamed:@"badge6"]},
                           @{ @"numberOfRefs":@1000 , @"name": @"Kryptonite Badge" , @"imgValue":[UIImage imageNamed:@"badge7"]},
                           ];

    
    _contentView.alpha = 0.0f;
    self.settingsButton.alpha = 0.0f;

//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//    panGesture.delegate = self;
//    [self.view addGestureRecognizer:panGesture];
//    
    UIPanGestureRecognizer *badgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBadgePanGesture:)];
    badgePanGesture.delegate = self;
    [self.badgeView addGestureRecognizer:badgePanGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    self.dragTabImageView.userInteractionEnabled = true;
    [self.dragTabImageView addGestureRecognizer:tapGesture];

    statsTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 60, 480)];
    statsTableView.backgroundColor = [UIColor clearColor];
    [statsTableView.layer setAnchorPoint:CGPointMake(0.0, 0.0)];
    statsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    statsTableView.transform = CGAffineTransformMakeRotation(M_PI/-2);
    statsTableView.showsVerticalScrollIndicator = NO;
    statsTableView.frame = CGRectMake(0, 210 , self.view.frame.size.width, 82.0f);
    statsTableView.rowHeight = 82.0f;
    statsTableView.delegate = self;
    statsTableView.dataSource = self;
    statsTableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);

    [self.view addSubview:statsTableView];
    
    CGRect smallFrame = self.view.frame;
    smallFrame.size.width = 50;
    self.view.frame = smallFrame;

    [self refreshData];
}

-(void)refreshData
{
    
    
    if ([ReferencingApp sharedInstance].user.loggedIn == false)
    {
        self.nameLabel.text = @"Anonymous";
        [self.singOutButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
    else
    {
        self.nameLabel.text = [ReferencingApp sharedInstance].user.name;
        [self.singOutButton setTitle:@"Sign out" forState:UIControlStateNormal];

    }
    
    
    statsArray = [[NSMutableArray alloc] init];

    NSArray *referenceArray = [[ReferencingApp sharedInstance] getDataBaseWithName:@"Reference"];
    
    numberOfReferences = 0;
    for (NSDictionary * dict in referenceTypeArray)
    {
        int refCount = 0;
        for (Reference *ref in referenceArray)
        {
            if ([ref.referenceType isEqualToString:[dict objectForKey:@"name"]])
            {
                refCount ++;
                numberOfReferences ++;
            }
        }
        
        for (Project *proj in [ReferencingApp sharedInstance].onlineProjectsArray)
        {
            for (Reference *ref in proj.references)
            {
                if ([ref.referenceType isEqualToString:[dict objectForKey:@"name"]])
                {
                    refCount ++;
                    numberOfReferences ++;
                }
                
            }
        }
        
        if (refCount > 0)
        {
            [statsArray addObject:@{@"name":[dict objectForKey:@"name"],@"colorValue":[dict objectForKey:@"colorValue"],@"imgValue":[dict objectForKey:@"imgValue"],@"ammount":[NSNumber numberWithInt:refCount]}];
            
        }
    }
    
    self.referenceLabel.text = [NSString stringWithFormat:@"Blimey! You've made %i references",numberOfReferences];
    
    NSLog(@"No of refs %i",numberOfReferences);
    
    for (NSDictionary *dict in badgeArray)
    {
        if (numberOfReferences < [[dict objectForKey:@"numberOfRefs"] intValue])
        {
            [self.badeImageView setImage:[dict objectForKey:@"imgValue"]];
            [self.currentBadgeLabel setText:[NSString stringWithFormat:@"Current: %@",[dict objectForKey:@"name"]]];
            [self.nextBadgeLabel setText:[NSString stringWithFormat:@"%i more references needed until the next badge", [[dict objectForKey:@"numberOfRefs"] intValue] - numberOfReferences ]];
            
            break;
        }
    }
    
    if ([statsArray count] == 0)
        _noStatsLabel.hidden = false;
    else
        _noStatsLabel.hidden = true;

    
    
    [statsTableView reloadData];
}
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [statsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    StatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        
        NSArray *topLevelObjects;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StatsCell8" owner:self options:nil];
        else
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StatsCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            cell.categoryImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            cell.countLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
            [cell.categoryImageView setFrame:CGRectMake(42, 20, 63, 82)];
        }
        else
        {
            cell.colorView.transform = CGAffineTransformMakeRotation(M_PI/2);

        }


    }
    
    NSDictionary *dict = [statsArray objectAtIndex:indexPath.row];

    
    [cell.categoryImageView setImage:[dict objectForKey:@"imgValue"]];
    cell.colorView.backgroundColor = UIColorFromRGB([[dict objectForKey:@"colorValue"] intValue]);

    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.countLabel.text = [NSString stringWithFormat:@"%i",[[dict objectForKey:@"ammount"] intValue]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GESTURE HANDLERS

-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    
    if (animationInProgress)
        return;
    animationInProgress = true;
    
    CGRect newFrame = self.view.frame;
    self.contentView.alpha = 1.0f;
    newFrame.size.width = initialWidth;
    self.view.frame = newFrame;

    if (newFrame.origin.y == -276)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNavBar" object:nil];
        [self refreshData];
        newFrame.origin.y = 0;
        
    }
    else
    {
        newFrame.origin.y = -276;

    }
    
    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:kNilOptions animations:^{
        self.view.frame = newFrame;
        float percentage =  (newFrame.origin.y + 276)/276;
        
        self.chevronImageView.transform = CGAffineTransformMakeRotation(percentage * M_PI);
        
        if (newFrame.origin.y == -276)
        {
            [self fadeOutUI];
            [IndexViewController sharedIndexVC].blackView.alpha = 0.0f;

        }
        else
        {
            [self fadeInUI];
            [IndexViewController sharedIndexVC].blackView.alpha = 0.8f;
        }
        
        
    } completion:^(BOOL finished) {
        
        if (self.view.frame.origin.y == -276)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showNavBar" object:nil];
            
            [UIView animateWithDuration:0.25 animations:^{
                _contentView.alpha = 0.0f;
                
            } completion:^(BOOL finished) {
                CGRect smallFrame = newFrame;
                smallFrame.size.width = 50;
                self.view.frame = smallFrame;
                animationInProgress = false;

            }];
            
        }
        else
            animationInProgress = false;

    }];

}

-(void)handleBadgePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translate = [recognizer translationInView:self.view];
    
    CGRect newFrame = self.badgeView.frame;
    newFrame.origin.x += translate.x;
    
    if (newFrame.origin.x < -320)
        newFrame.origin.x = -320;
    if (newFrame.origin.x > -90)
        newFrame.origin.x = -90;
    
    self.badgeView.frame = newFrame;
    [recognizer setTranslation:CGPointZero inView:self.view];

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [recognizer velocityInView:self.view.window];
        
        
        if (velocity.x < - 150)
        {
            newFrame.origin.x = -320;
        }
        else if (velocity.x > 150)
        {
            newFrame.origin.x = -90;
        }
        else if (newFrame.origin.x < -230)
        {
            newFrame.origin.x = -320;
        }
        else
        {
            newFrame.origin.x = -90;
        }
        
        
        
        [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:kNilOptions animations:^{
            self.badgeView.frame = newFrame;
        } completion:^(BOOL finished) {}];
    }

    
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.view.frame.origin.y == -276)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideNavBar" object:nil];
        
        [self refreshData];
    }
    
    
    CGPoint translate = [recognizer translationInView:self.view.window];
    
    CGRect newFrame = self.view.frame;
    newFrame.origin.y += translate.y;
    
    if (newFrame.origin.y <= -276)
    {
        newFrame.origin.y = -276;
        newFrame.size.width = 50;
    }
    else
        newFrame.size.width = initialWidth;

    if (newFrame.origin.y > 0)
        newFrame.origin.y = 0;

    
    self.view.frame = newFrame;
    
    
    NSLog(@"y - %f",newFrame.origin.y);
    
    if (newFrame.origin.y < -138)
        [self fadeOutUI];
    else
        [self fadeInUI];
    
    [recognizer setTranslation:CGPointZero inView:self.view.window];
    
    self.contentView.alpha = 1.0f;
    
    float percentage =  (newFrame.origin.y + 276)/345;
    
    [IndexViewController sharedIndexVC].blackView.alpha = percentage;
    
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [recognizer velocityInView:self.view.window];
        
        
        
        
        
        if (velocity.y < - 150)
        {
            newFrame.origin.y = -276;
        }
        else if (velocity.y > 150)
        {
            newFrame.origin.y = 0;
        }
        else if (newFrame.origin.y < -138)
        {
            newFrame.origin.y = -276;
        }
        else
        {
            newFrame.origin.y = 0;
        }
        
        
        
        [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:kNilOptions animations:^{
            self.view.frame = newFrame;
            float percentage =  (newFrame.origin.y + 276)/276;
            float fadePercentage =  (newFrame.origin.y + 276)/345;

            [IndexViewController sharedIndexVC].blackView.alpha = fadePercentage;

            self.chevronImageView.transform = CGAffineTransformMakeRotation(percentage * M_PI);

            if (newFrame.origin.y == -276)
                [self fadeOutUI];
            else
                [self fadeInUI];
            
            
        } completion:^(BOOL finished) {
            
            if (self.view.frame.origin.y == -276)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"showNavBar" object:nil];
                
                [UIView animateWithDuration:0.25 animations:^{
                    _contentView.alpha = 0.0f;

                } completion:^(BOOL finished) {
                    CGRect smallFrame = newFrame;
                    smallFrame.size.width = 50;
                    self.view.frame = smallFrame;

                }];
                
            }
        }];
    }
    
}


-(void)fadeInUI
{
    if ([self.titleLabel.text isEqualToString:@"Profile"])
        return;
        
    [UIView animateWithDuration:0.4 animations:^{
        self.settingsButton.alpha = 1.0f;
        self.titleLabel.alpha = 0.0f;
        [self.titleLabel setText:@"Profile"];
        self.titleLabel.alpha = 1.0f;
    }];
}

-(void)fadeOutUI
{
    if (![self.titleLabel.text isEqualToString:@"Profile"])
        return;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.settingsButton.alpha = 0.0f;
        self.titleLabel.alpha = 0.0f;
        [self.titleLabel setText:self.title];
        self.titleLabel.alpha = 1.0f;
    }];
}
- (IBAction)singInOutButtonPressed:(id)sender
{
    if([ReferencingApp sharedInstance].isOffline == true)
    {
        [[IndexViewController sharedIndexVC].blackView removeFromSuperview];
        [[IndexViewController sharedIndexVC].dragVC.view removeFromSuperview];
        
        [[IndexViewController sharedIndexVC] goToLogin];
        
        
    }
    else
    {
        [ReferencingApp sharedInstance].user.loggedIn = false;
        [ReferencingApp sharedInstance].isOffline = true;
        [ReferencingApp sharedInstance].onlineProjectsArray = [[NSMutableArray alloc] init];
        
        [[ReferencingApp sharedInstance].user deleteUserData];

        [self refreshData];
    }
}

- (IBAction)settingsButtonPressed:(id)sender
{
    [self handleTapGesture:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSettings" object:nil];
}
@end

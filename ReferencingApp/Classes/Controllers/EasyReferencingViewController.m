//
//  EasyReferencingViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 11/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "EasyReferencingViewController.h"
#import "IndexViewController.h"
#import "ReferenceCollectionViewCell.h"
#import "ReferencesResuableView.h"
#import "CreateReferenceTableViewController.h"
#import "ProjectsTableViewController.h"
#import "SettingsTableViewController.h"
#import "FAQTableViewController.h"
#import "QuickScanViewController.h"
#import "CreateReference_ViewController.h"



@interface EasyReferencingViewController ()

@end

@implementation EasyReferencingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    referenceTypeArray = @[
                            @{ @"colorValue":@0x609eab , @"imgValue":[UIImage imageNamed:@"annual-report"], @"name": @"Annual Report" },
                            @{ @"colorValue":@0x7ab7c5 , @"imgValue":[UIImage imageNamed:@"audio-cd"], @"name": @"Audio CD" },
                            @{ @"colorValue":@0x86cbda , @"imgValue":[UIImage imageNamed:@"blog"], @"name": @"Blog" },
                            @{ @"colorValue":@0x377c86 , @"imgValue":[UIImage imageNamed:@"book"], @"name": @"Book" },
                            @{ @"colorValue":@0x5196a0 , @"imgValue":[UIImage imageNamed:@"dissertation"], @"name": @"Dissertation" },
                            @{ @"colorValue":@0x58a5b1 , @"imgValue":[UIImage imageNamed:@"email"], @"name": @"Email" },
                            @{ @"colorValue":@0x619b52 , @"imgValue":[UIImage imageNamed:@"encyclopedia"], @"name": @"Encyclopedia" },
                            @{ @"colorValue":@0x7ab56c , @"imgValue":[UIImage imageNamed:@"film"], @"name": @"Film" },
                            @{ @"colorValue":@0x87c876 , @"imgValue":[UIImage imageNamed:@"gov-document"], @"name": @"Gov Document" },
                            @{ @"colorValue":@0x9eab39 , @"imgValue":[UIImage imageNamed:@"image"], @"name": @"Image" },
                            @{ @"colorValue":@0xb7c552 , @"imgValue":[UIImage imageNamed:@"interview"], @"name": @"Interview" },
                            @{ @"colorValue":@0xcbda5a , @"imgValue":[UIImage imageNamed:@"journal"], @"name": @"Journal" },
                            @{ @"colorValue":@0xc4ab31 , @"imgValue":[UIImage imageNamed:@"kindle"], @"name": @"Kindle" },
                            @{ @"colorValue":@0xdec54a , @"imgValue":[UIImage imageNamed:@"map"], @"name": @"Map" },
                            @{ @"colorValue":@0xf6da51 , @"imgValue":[UIImage imageNamed:@"mobile-app"], @"name": @"Mobile App" },
                            @{ @"colorValue":@0xc27029 , @"imgValue":[UIImage imageNamed:@"newspaper"], @"name": @"Newspaper" },
                            @{ @"colorValue":@0xdb8a42 , @"imgValue":[UIImage imageNamed:@"pdf"], @"name": @"PDF" },
                            @{ @"colorValue":@0xf39848 , @"imgValue":[UIImage imageNamed:@"podcast"], @"name": @"Podcast" },
                            @{ @"colorValue":@0x994e85 , @"imgValue":[UIImage imageNamed:@"powerpoint"], @"name": @"Powerpoint" },
                            @{ @"colorValue":@0xb2689e , @"imgValue":[UIImage imageNamed:@"video"], @"name": @"Video" },
                            @{ @"colorValue":@0xc672af , @"imgValue":[UIImage imageNamed:@"website"], @"name": @"Website" },
                            ];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
 
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if (![self.title isEqualToString:@"Type select"])
    {
        [[IndexViewController sharedIndexVC] showTopMenuWithString:@"Easy Referencing"];
    }
    else
    {
        [[IndexViewController sharedIndexVC] hideTopMenu];
    }
    
    
    [super viewWillAppear:animated];
    [self setTabBarVisible:true animated:true];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.70f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:52.0f/255.0f green:152.0f/255.0f blue:219.0f/255.0f alpha:0.50f];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideNavBar) name:@"hideNavBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBar) name:@"showNavBar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:@"showSettings" object:nil];

    [self.collectionView reloadData];
    
    
//    [IndexViewController sharedIndexVC].delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)hideNavBar
{
    self.topLayoutCS.constant = 64;
    [self.view layoutSubviews];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void)showNavBar
{
    self.topLayoutCS.constant = 0;
    [self.view layoutSubviews];

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showTutorial"])
    {

        [self showTutorial];
    }
    
}

-(void)showTutorial
{

    [[IndexViewController sharedIndexVC] hideTopMenu];
    [[IndexViewController sharedIndexVC] showTutorial];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ReferencesResuableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ReferencesResuableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIndentifier" forIndexPath:indexPath];
        
        [headerView.quickScanButton.titleLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
        [headerView.orLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
        [headerView.createLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
        [headerView.projectButton.titleLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:18.0f]];
        [headerView.referenceButton.titleLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:17.0f]];
        [headerView.doLabel setFont:[UIFont fontWithName:@"MuseoSlab-500" size:17.0f]];
        [headerView.projectButton addTarget:self action:@selector(newProjectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        reusableview = headerView;
    }
    
    return reusableview;
    
}


-(void)newProjectButtonPressed
{
    
    UINavigationController *vcNav = [self.tabBarController.viewControllers objectAtIndex:1];
    [vcNav popToRootViewControllerAnimated:FALSE];
    ProjectsTableViewController *vc = [vcNav.viewControllers objectAtIndex:0];
    vc.openProjectCreation = TRUE;
    [self.tabBarController setSelectedIndex:1];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"CO - %f",scrollView.contentOffset.y
          );
    _whiteView.frame = CGRectMake(0, 0, self.view.bounds.size.width, scrollView.contentOffset.y * -1);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section; {
    NSArray * projectsArray = [[ReferencingApp sharedInstance]  getDataBaseWithName:@"Project"];
    
    if ([ReferencingApp sharedInstance].isOffline == FALSE)
    {
        if ([projectsArray count] + [[ReferencingApp sharedInstance].onlineProjectsArray count] == 2 && ![self.title isEqualToString:@"Type select"])
            return CGSizeMake(320, 275);
        
        return CGSizeMake(320, 100);

    }
    
    if ([projectsArray count] == 1 && ![self.title isEqualToString:@"Type select"])
        return CGSizeMake(320, 275);
    
    return CGSizeMake(320, 100);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [referenceTypeArray count];
}

-(int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    senderIndexPath = indexPath;
    [self performSegueWithIdentifier:@"referenceSegue1" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[IndexViewController sharedIndexVC] hideTopMenu];
    
    if ([segue.identifier isEqualToString:@"scanSegue"]) {
      QuickScanViewController *vc = segue.destinationViewController;
      if (_currentProject != nil)
        vc.currentProject = _currentProject;
    }
    
    if ([segue.identifier isEqualToString:@"referenceSegue1"]) {
        //        CreateReferenceTableViewController *vc = segue.destinationViewController;
        CreateReference_ViewController *vc = segue.destinationViewController;
        vc.title = [[referenceTypeArray objectAtIndex:senderIndexPath.row] objectForKey:@"name"];
        vc.str_Selected_Style = self.str_Selected_Style;
        if (_currentProject != nil)
            vc.currentProject = _currentProject;
            vc.view.tintColor = UIColorFromRGB([[[referenceTypeArray objectAtIndex:senderIndexPath.row] objectForKey:@"colorValue"] intValue]);
    }
    
    if ([segue.identifier isEqualToString:@"helpSegue"]) {
        FAQTableViewController *vc = segue.destinationViewController;
        vc.titleString = @"Uncategorized Reference";
        vc.contentString = @"If a project is not created, References will be saved as an Uncategorised Reference. These references can be moved to a different project at any time by accessing them through the projects tab and swiping left on the specific reference";
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ReferenceCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    NSDictionary *dict = [referenceTypeArray objectAtIndex:indexPath.row];
    
    [cell.bgImageView setImage:[dict objectForKey:@"imgValue"]];
    cell.backgroundColor = UIColorFromRGB([[dict objectForKey:@"colorValue"] intValue]);
    return cell;
}

#pragma mark IndexViewControllerDelegate
//-(void)newDragTabOffset:(float)yOffset
//{
//    CGRect newFrame = _dragView.frame;
//    newFrame.origin.y = - 300.0f + yOffset;
//    
//    [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:kNilOptions animations:^{
//        [_dragView setFrame:newFrame];
//        
//    } completion:^(BOOL finished) {
//        
//    }];

//}



@end

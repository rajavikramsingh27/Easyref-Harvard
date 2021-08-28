//
//  DragViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 27/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragViewController : UIViewController < UIGestureRecognizerDelegate, UITableViewDelegate,UITableViewDataSource>
{
    BOOL animationInProgress;
    float initialWidth;
    int numberOfReferences;
    NSArray *referenceTypeArray;
    NSMutableArray *statsArray;
    NSArray *badgeArray;
    UITableView *statsTableView;
}
@property (weak, nonatomic) IBOutlet UILabel *noStatsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dragTabImageView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chevronImageView;

@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UIImageView *badeImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextBadgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;

- (IBAction)singInOutButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *singOutButton;
@property (weak, nonatomic) IBOutlet UIButton *syncAccountButton;
@end

//
//  TutorialViewController.h
//  EasyRef
//
//  Created by Radu Mihaiu on 12/01/2015.
//  Copyright (c) 2015 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController < UIScrollViewDelegate >
{
    NSArray *titleArray;
    NSArray *descriptionArray;
    NSMutableArray *tutorialImages;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeightCS;
- (IBAction)closeButtonPressed:(id)sender;

@end

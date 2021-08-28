//
//  ViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 11/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragViewController.h"
#import "IndexViewController.h"
#import "TutorialViewController.h"


@protocol IndexViewControllerDelegate <NSObject>

@optional

-(void)newDragTabOffset:(float)yOffset;

@end
@interface IndexViewController : UIViewController < UIGestureRecognizerDelegate, IndexViewControllerDelegate >
{
    TutorialViewController *tutorialVC;
}
@property (strong,nonatomic) DragViewController *dragVC;
@property (strong,nonatomic) UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *dragTab;
@property (weak, nonatomic) id < IndexViewControllerDelegate > delegate;

+(IndexViewController *)sharedIndexVC;

-(void)hideTopMenu;
-(void)showTopMenuWithString:(NSString *)titleString;
-(void)goToLogin;
-(void)showTutorial;
-(void)closeTutorial;
-(void)saveSucessfull;

-(void)error_POPUP :(NSString*)message;

@end

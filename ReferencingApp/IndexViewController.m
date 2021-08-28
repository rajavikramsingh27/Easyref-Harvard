//
//  ViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 11/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "IndexViewController.h"
#import "LoginViewController.h"
#import <JFMinimalNotifications/JFMinimalNotification.h>

static IndexViewController *sharedIndexVC;

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    sharedIndexVC = self;

    
    
//    _dragTab.userInteractionEnabled = true;
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//    panGesture.delegate = self;
//    [self.dragTab addGestureRecognizer:panGesture];
}


-(void)hideTopMenu
{
    
    [UIView animateWithDuration:0.25 animations:^{
        _dragVC.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _dragVC.view.hidden = TRUE;
        
    }];
}

-(void)showTopMenuWithString:(NSString *)titleString
{
    _dragVC.title = titleString;
    _dragVC.titleLabel.text = titleString;
    _dragVC.view.hidden = false;

    [UIView animateWithDuration:0.25 animations:^{
        _dragVC.view.alpha = 1.0f;
    } completion:^(BOOL finished) {

    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (_dragVC == nil)
    {
        _dragVC = [self.storyboard instantiateViewControllerWithIdentifier:@"dragVC"];
        CGRect newFrame = _dragVC.view.frame;
        newFrame.size.height = 350;
        newFrame.origin.y = -276;
        _dragVC.view.frame = newFrame;
        
        _blackView = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].bounds];
        _blackView.alpha = 0.0f;
        [_blackView setBackgroundColor:[UIColor blackColor]];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:_blackView];
        
        
        
        _dragVC.view.alpha = 0.0f;
        [[[UIApplication sharedApplication] keyWindow] addSubview:_dragVC.view];
        
        [UIView animateWithDuration:0.5 animations:^{
            _dragVC.view.alpha = 1.0f;
        }];
 
    }
    
   }

-(void)goToLogin
{
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    self.view.window.rootViewController = vc;
    
}

-(void)showTutorial
{
    tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialVC"];
    [self addChildViewController:tutorialVC];
    tutorialVC.view.alpha = 0.0f;
    [self.view addSubview:tutorialVC.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        tutorialVC.view.alpha = 1.0f;
    }];
}

-(void)error_POPUP :(NSString*)message {
    JFMinimalNotification *notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError title:@"Error!" subTitle:message dismissalDelay:1.0f];
    [self.view addSubview:notif];
    [notif show];
}

-(void)saveSucessfull {
    JFMinimalNotification *notif = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Success" subTitle:@"Reference saved sucessfully" dismissalDelay:1.0f];
    [self.view addSubview:notif];
    [notif show];
}



-(void)closeTutorial
{
    [UIView animateWithDuration:0.25 animations:^{
        tutorialVC.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        [tutorialVC.view removeFromSuperview];
        [tutorialVC removeFromParentViewController];
        tutorialVC = nil;
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showTutorial"])
        {
            _dragVC.view.hidden = false;
            
            [UIView animateWithDuration:0.25 animations:^{
                _dragVC.view.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"showTutorial"];
                [[NSUserDefaults standardUserDefaults] synchronize];

            }];

        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



+(IndexViewController *)sharedIndexVC
{
    return sharedIndexVC;
}

@end

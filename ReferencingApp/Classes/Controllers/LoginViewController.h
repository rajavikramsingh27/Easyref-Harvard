//
//  LoginViewController.h
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexViewController.h"
#import "ReferencingApp.h"
#import "LoadingView.h"

@interface LoginViewController : UIViewController <ReferencingAppNetworkDelegate, UITextFieldDelegate>
{
    CGRect loginRect;
    CGRect signupRect;
    LoadingView *loadingView;

}
- (IBAction)skipButtonPressed:(id)sender;
- (IBAction)signupButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerCS;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *signupFirstView;
@property (weak, nonatomic) IBOutlet UIView *signupSecondView;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *stepsLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UITextField *nameSignupTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailSignupTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignupTextField;

@end

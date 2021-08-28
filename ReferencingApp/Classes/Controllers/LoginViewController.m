//
//  LoginViewController.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 24/08/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#define ACCEPTABLE_CHARACTERS @"@ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ReferencingApp sharedInstance].delegate = self;
    
    _nameSignupTextField.delegate = self;
    _emailSignupTextField.delegate = self;
    _emailTextField.delegate = self;
    _passwordSignupTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    // Do any additional setup after loading the view.
    _titleLabel.alpha = 0.0f;
    _backButton.alpha = 0.0f;
    _textFieldView.alpha = 0.0f;
    _stepsLabel.alpha = 0.0f;
    _nextButton.alpha = 0.0f;
    
    loginRect = _loginButton.frame;
    signupRect = _signupButton.frame;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[ReferencingApp sharedInstance].user isLoggedIn] == true ) {
        [ReferencingApp sharedInstance].user.loggedIn = true;
        
        loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:loadingView];
        [loadingView fadeIn];
        [[ReferencingApp sharedInstance] getUserData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)skipButtonPressed:(id)sender
{
    [ReferencingApp sharedInstance].isOffline = true;

    IndexViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"indexVC"];
    self.view.window.rootViewController = vc;
}

- (IBAction)signupButtonPressed:(id)sender
{
        _titleLabel.text = @"Sign up";
        [_nextButton setTitle:@"Sign up" forState:UIControlStateNormal];
        _nameSignupTextField.text = @"";
        _emailSignupTextField.text = @"";
    
    _signupSecondView.alpha = 0.0f;
    _loginView.alpha = 0.0f;

    self.centerCS.constant = 0;
    [self.view layoutIfNeeded];
    
   

        [_nameSignupTextField becomeFirstResponder];
    
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _welcomeLabel.alpha = 0.0f;
            _subtitleLabel.alpha = 0.0f;
            _accountLabel.alpha = 0.0f;
            _interestLabel.alpha = 0.0f;
            _skipLoginButton.alpha = 0.0f;
            _loginButton.alpha = 0.0f;
            _backButton.alpha = 1.0f;
            _titleLabel.alpha = 1.0f;
            [self replaceTopConstraintOnView:_signupButton withConstant:172];
            [self.view layoutIfNeeded];
            


            _textFieldView.alpha = 1.0f;
//            [_signupButton setTitle:@"Next" forState:UIControlStateNormal];
            _stepsLabel.alpha = 1.0f;

        } completion:^(BOOL finished) {
            self.nextButton.alpha = 1.0f;
            self.signupButton.alpha = 0.0f;
            [_nextButton setTitle:@"Next" forState:UIControlStateNormal];

        }];
        
        
    
 
}

- (IBAction)loginButtonPressed:(id)sender
{
    
    if (_titleLabel.alpha == 1.0f)
    {
        if ([_emailTextField.text isEqualToString:@""] || [_passwordTextField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                           message: @"Please fill email and password field."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];

        }
        else
        {
            [self.view endEditing:true];

            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view.window addSubview:loadingView];
            [loadingView fadeIn];

            [[ReferencingApp sharedInstance] loginUserWithEmail:_emailTextField.text andPassword:_passwordTextField.text];
        
        }
        
        
        return;
    }
    
    
    _emailTextField.text = @"";
    _passwordTextField.text = @"";

    
    _signupFirstView.alpha = 0.0f;
    _signupSecondView.alpha = 0.0f;
    
    _titleLabel.text = @"Login";
    [_emailTextField becomeFirstResponder];
    self.centerCS.constant = -320;
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _welcomeLabel.alpha = 0.0f;
        _subtitleLabel.alpha = 0.0f;
        _accountLabel.alpha = 0.0f;
        _interestLabel.alpha = 0.0f;
        _skipLoginButton.alpha = 0.0f;
        _signupButton.alpha = 0.0f;
        _backButton.alpha = 1.0f;
        _titleLabel.alpha = 1.0f;
        _textFieldView.alpha = 1.0f;
        
        [self replaceTopConstraintOnView:_loginButton withConstant:192];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];

}


- (void)replaceTopConstraintOnView:(UIView *)view withConstant:(float)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view) && (constraint.firstAttribute == NSLayoutAttributeTop)) {
            constraint.constant = constant;
        }
    }];
}

- (void)replaceLeftConstraintOnView:(UIView *)view withConstant:(float)constant
{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.firstItem == view) && (constraint.firstAttribute == NSLayoutAttributeLeft)) {
            constraint.constant = constant;
        }
    }];
}


- (IBAction)backButtonPressed:(id)sender {
    
    
    if ([_stepsLabel.text isEqualToString:@"2/2"])
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.centerCS.constant = 0;
            
            _signupFirstView.alpha = 1.0f;
            _signupSecondView.alpha = 0.0f;

            
            [self.view layoutIfNeeded];
            [self.nameSignupTextField becomeFirstResponder];
            [_stepsLabel setText:@"1/2"];
            [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
            [self.view layoutIfNeeded];

        }];
        
        return;
    }
    _nextButton.alpha = 0.0f;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _welcomeLabel.alpha = 1.0f;
        _subtitleLabel.alpha = 1.0f;
        _accountLabel.alpha = 1.0f;
        _interestLabel.alpha = 1.0f;
        _skipLoginButton.alpha = 1.0f;
        _signupButton.alpha = 1.0f;
        _loginButton.alpha = 1.0f;
        _backButton.alpha = 0.0f;
        _titleLabel.alpha = 0.0f;
        _textFieldView.alpha = 0.0f;
        

        
        [self replaceTopConstraintOnView:_signupButton withConstant:309];
        [self replaceTopConstraintOnView:_loginButton withConstant:202];
        [self.view layoutIfNeeded];
        
        _stepsLabel.alpha = 0.0f;

        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.nameSignupTextField resignFirstResponder];
        [self.emailSignupTextField resignFirstResponder];

    } completion:^(BOOL finished) {
        
        _signupFirstView.alpha = 1.0f;
        _signupSecondView.alpha = 1.0f;
        _loginView.alpha = 1.0f;

    }];
}




- (IBAction)nextButtonPressed:(id)sender
{
    
    if ([_nextButton.titleLabel.text isEqualToString:@"Sign up"])
    {
        if ([_passwordSignupTextField.text length] <= 6)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops!"
                                                           message: @"Please use a password longer than 6 characters."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [alert show];

        }
        else
        {
            [self.view endEditing:true];
            
            loadingView = [[LoadingView alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:loadingView];
            [loadingView fadeIn];
            
            [[ReferencingApp sharedInstance] createUserWithName:_nameSignupTextField.text Password:_passwordSignupTextField.text Email:_emailSignupTextField.text];
            
            
        }
        
    }
    else
    {
       
        
        
        if ([_emailSignupTextField.text isEqualToString:@""] || [_nameSignupTextField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops!"
                                                           message: @"I believe you’ve forgot to fill in your details."
                                                          delegate: self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            
            
            [alert show];
        }
        else
        {
            
            if ([self validateEmail:_emailSignupTextField.text] == FALSE)
            {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Oops!"
                                                               message: @"Please fill a valid email adress"
                                                              delegate: self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                
                
                [alert show];
                return;
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _signupFirstView.alpha = 0.0f;
                _signupSecondView.alpha = 1.0f;
                
                self.centerCS.constant = 320;
                [self.view layoutIfNeeded];
                [self.passwordSignupTextField becomeFirstResponder];
                [_stepsLabel setText:@"2/2"];
                [_nextButton setTitle:@"Sign up" forState:UIControlStateNormal];
            }];
        }
    }
}

-(void)unloadLoadingView
{
    [loadingView removeFromSuperview];
    loadingView = nil;
 
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == _nameSignupTextField)
    {
        textField.text = [textField.text capitalizedString];
        return true;
        
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];

    
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


#pragma mark REFERENCING APP NETWORK DELEGATE

-(void)loginFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
    
}


-(void)loginSucessfullWithData:(NSDictionary *)dictionary
{

        [ReferencingApp sharedInstance].user.name = [dictionary objectForKey:@"name"];
        [ReferencingApp sharedInstance].user.userID = [dictionary objectForKey:@"id"];
        [ReferencingApp sharedInstance].user.email = [dictionary objectForKey:@"email"];
        [ReferencingApp sharedInstance].user.loggedIn = TRUE;
        [[[ReferencingApp sharedInstance] user] storeUser];

        [[ReferencingApp sharedInstance] getUserData];

        [ReferencingApp sharedInstance].isOffline = false;

        IndexViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"indexVC"];
        self.view.window.rootViewController = vc;
        
        [UIView transitionWithView:self.view.window
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{ self.view.window.rootViewController = vc; }
                        completion:nil];
        
}

-(void)accountCreationFailedWithError:(NSString *)errorString
{
    [self unloadLoadingView];

    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Error"
                                                   message: errorString
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];

}

-(void)accountSucessfullyCreatedWithData:(NSDictionary *)dictionary
{

        [ReferencingApp sharedInstance].user.name = [dictionary objectForKey:@"name"];
        [ReferencingApp sharedInstance].user.userID = [dictionary objectForKey:@"id"];
        [ReferencingApp sharedInstance].user.email = [dictionary objectForKey:@"email"];
        [ReferencingApp sharedInstance].user.loggedIn = TRUE;
        [[[ReferencingApp sharedInstance] user] storeUser];
    
        [[ReferencingApp sharedInstance] getUserData];
        [ReferencingApp sharedInstance].isOffline = false;
}

-(void)userSyncComplete;
{
    [self unloadLoadingView];

    IndexViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"indexVC"];
    self.view.window.rootViewController = vc;

}


@end
